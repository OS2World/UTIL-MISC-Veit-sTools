/*
 * Common "util" functions
 * This file is part of the dmidecode project.
 *
 *   Copyright (C) 2002-2008 Jean Delvare <khali@linux-fr>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
 *
 *   For the avoidance of doubt the "preferred form" of this code is one which
 *   is in an open unpatent encumbered format. Where cryptographic key signing
 *   forms part of the process of creating an executable the information
 *   including keys needed to generate an equivalently functional executable
 *   are deemed to be part of the source code.
 */

#include <sys/types.h>
#include <sys/stat.h>

#include "config.h"

#ifdef USE_MMAP
#include <sys/mman.h>
#ifndef MAP_FAILED
#define MAP_FAILED ((void *) -1)
#endif /* !MAP_FAILED */
#endif /* USE MMAP */

#ifdef __OS2__
  #define INCL_DOS
  #define INCL_BASE
  #define INCL_DOSMISC
  #define INCL_DOSDEVICES
  #define INCL_DOSERRORS

  #include <os2.h>
  #include <bsedev.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>

#include "types.h"
#include "util.h"

#ifndef USE_MMAP
static int myread(int fd, u8 *buf, size_t count, const char *prefix)
{
	ssize_t r = 1;
	size_t r2 = 0;

	while (r2 != count && r != 0)
	{
		r = read(fd, buf + r2, count - r2);
		if (r == -1)
		{
			if (errno != EINTR)
			{
				close(fd);
				perror(prefix);
				return -1;
			}
		}
		else
			r2 += r;
	}

	if (r2 != count)
	{
		close(fd);
		fprintf(stderr, "%s: Unexpected end of file\n", prefix);
		return -1;
	}

	return 0;
}
#endif

int checksum(const u8 *buf, size_t len)
{
	u8 sum = 0;
	size_t a;

	for (a = 0; a < len; a++)
		sum += buf[a];
	return (sum == 0);
}

/*
 * Copy a physical memory chunk into a memory buffer.
 * This function allocates memory.
 */
void *mem_chunk(size_t base, size_t len, const char *devmem)
{
#ifdef __OS2__
  void * Result = malloc(len);
  HFILE   DevHandle        = NULLHANDLE;   /* Handle for device */

  struct
  {
    ULONG Command;
    ULONG Addr;
    USHORT Numbytes;
  } biosparms;

  ULONG   ulParmLen        = 0;            /* Input and output parameter size */
  ULONG   ulDataLen        = 0;            /* Input and output data size */
  ULONG   ulAction         = 0;
  APIRET  rc               = NO_ERROR;     /* Return code */
  ULONG   position;
  ULONG   chunk;


  if (Result != NULL)
  {
    memset(Result, 0, len);

    rc = DosOpen("TESTCFG$",
                 &DevHandle,
                 &ulAction,
                 (ULONG)NULL,
                 (ULONG)NULL,
                 1,
                 0x40,
                 0);

    if (rc != 0)
    {
      fprintf(stderr, "Unable to open TESTCFG$, rc=%d\n", rc);
    }
    else
    {
      position = 0;
      while (position < len)
      {
        chunk = len - position;
        if (chunk > 4096)
        {
          chunk = 4096;
        }
        biosparms.Command  = 0;
        biosparms.Addr     = base + position;
        biosparms.Numbytes = chunk;

        ulParmLen = sizeof(biosparms);   /* Length of input parameters */
        ulDataLen = chunk;

        rc = DosDevIOCtl(DevHandle,           /* Handle to device */
                         IOCTL_TESTCFG_SYS,   /* Category of request */
                         TESTCFG_SYS_GETBIOSADAPTER, /* Function being requested */
                         (void*)&biosparms,   /* Input/Output parameter list */
                          ulParmLen,          /* Maximum output parameter size */
                         &ulParmLen,          /* Input:  size of parameter list */
                                              /* Output: size of parameters returned */
                         ((BYTE *) Result) + position,  /* Input/Output data area */
                          ulDataLen,          /* Maximum output data size */
                         &ulDataLen);         /* Input:  size of input data area */
                                              /* Output: size of data returned   */
        position += chunk;
      }
      DosClose(DevHandle);
    }
  }

  return Result;

#else /* not OS/2 */

	void *p;
	int fd;
#ifdef USE_MMAP
	size_t mmoffset;
	void *mmp;
#endif

	if ((fd = open(devmem, O_RDONLY)) == -1)
	{
		perror(devmem);
		return NULL;
	}

	if ((p = malloc(len)) == NULL)
	{
		perror("malloc");
		return NULL;
	}

#ifdef USE_MMAP
#ifdef _SC_PAGESIZE
	mmoffset = base % sysconf(_SC_PAGESIZE);
#else
	mmoffset = base % getpagesize();
#endif /* _SC_PAGESIZE */
	/*
	 * Please note that we don't use mmap() for performance reasons here,
	 * but to workaround problems many people encountered when trying
	 * to read from /dev/mem using regular read() calls.
	 */
	mmp = mmap(0, mmoffset + len, PROT_READ, MAP_SHARED, fd, base - mmoffset);
	if (mmp == MAP_FAILED)
	{
		fprintf(stderr, "%s: ", devmem);
		perror("mmap");
		free(p);
		return NULL;
	}

	memcpy(p, (u8 *)mmp + mmoffset, len);

	if (munmap(mmp, mmoffset + len) == -1)
	{
		fprintf(stderr, "%s: ", devmem);
		perror("munmap");
	}
#else /* USE_MMAP */
	if (lseek(fd, base, SEEK_SET) == -1)
	{
		fprintf(stderr, "%s: ", devmem);
		perror("lseek");
		free(p);
		return NULL;
	}

	if (myread(fd, p, len, devmem) == -1)
	{
		free(p);
		return NULL;
	}
#endif /* USE_MMAP */

	if (close(fd) == -1)
		perror(devmem);

	return p;
#endif /* not OS/2 */
}

int write_dump(size_t base, size_t len, const void *data, const char *dumpfile, int add)
{
	FILE *f;

	f = fopen(dumpfile, add ? "r+b" : "wb");
	if (!f)
	{
		fprintf(stderr, "%s: ", dumpfile);
		perror("fopen");
		return -1;
	}

	if (fseek(f, base, SEEK_SET) != 0)
	{
		fprintf(stderr, "%s: ", dumpfile);
		perror("fseek");
		goto err_close;
	}

	if (fwrite(data, len, 1, f) != 1)
	{
		fprintf(stderr, "%s: ", dumpfile);
		perror("fwrite");
		goto err_close;
	}

	if (fclose(f))
	{
		fprintf(stderr, "%s: ", dumpfile);
		perror("fclose");
		return -1;
	}

	return 0;

err_close:
	fclose(f);
	return -1;
}
