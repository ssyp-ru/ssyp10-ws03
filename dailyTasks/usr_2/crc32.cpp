 	                                                                                 Прошу прощения, что на С++, но сам алгоритм тот же. Пример для NULL - terminate строки, недавно как то писал Может, кому интересно будет.
Код:
CRC.H:

class Crc32
{  
public:	
	Crc32();
   
	/*Функция, вычисляющая контрольную сумму 
для переданной 	null - terminated строки.*/
    unsigned int ProcessString(const char* s);

private:
	 unsigned int table[256];
};


CRC.CPP:

#include "Crc32.h"

Crc32::Crc32()
{
	const unsigned int CRC_POLY = 0xEDB88320;
	unsigned int i, j, r;
	for (i = 0; i < 256; i++)
	{
		for (r = i, j = 8; j; j--) r = r & 1? (r >> 1) ^ CRC_POLY: r >> 1;
		table[i] = r;
	}
}

unsigned int Crc32::ProcessString(const char* s)
{
	const unsigned int  CRC_MASK = 0xD202EF8D;
	register const unsigned char* pdata = reinterpret_cast<const unsigned char*>(s);
	register unsigned int crc = 0; //_resultCrc32;
	static int i = 0;
	for(i = 0; pdata[i]; )
	{
		crc = table[static_cast<unsigned char>(crc) ^ *pdata++] ^ crc >> 8;
		crc ^= CRC_MASK;
	}
	return crc;
}
