#include <stdint.h>

char* send_line(uint32_t val){

    static char buf[9] = { '0', '0', '0', '0', '0', '0', '0', '0', '0'  };
    int i = 8;

    buf[0] = '0';
    buf[1] = '0';
    buf[2] = '0';
    buf[3] = '0';
    buf[4] = '0';
    buf[5] = '0';
    buf[6] = '0';
    buf[7] = '0';
    buf[8] = '0';

    for(; val && i ; --i, val /= 16) {
        buf[i] = "0123456789abcdef"[val % 16];
    }

    // return &buf[i+1];
    return &buf[1];
}

void send_signature(uint32_t *start, uint32_t bytes)
{
	uint32_t *uart = (uint32_t *) 0x10013000;
	
	uint32_t *current = start;

	for (int i = 0; i < (bytes / 4); i++) {
		char *buf = send_line(*current);

		for (int j = 0; j < 8; j++) {
			*uart = buf[j];
		}

		*uart = '\n';

		current++;
	}
}