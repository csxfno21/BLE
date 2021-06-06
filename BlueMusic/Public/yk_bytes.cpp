#include<stdio.h>
#include<string.h>
#include<assert.h>

#include "yk_bytes.h"


Yk_Bytes::Yk_Bytes()
{
	m_pData = NULL;
	m_nLen = 0;
}

Yk_Bytes::~Yk_Bytes(void)
{
	delete [] m_pData;
	m_nLen = 0;
}

Yk_Bytes::Yk_Bytes(unsigned int len)
{
	m_nLen = len;
	m_pData = new unsigned char[m_nLen];
	memset(m_pData, 0, m_nLen);
}

Yk_Bytes::Yk_Bytes(unsigned int len, const char* pData)
{
	if (pData == NULL)
	{
		m_pData = NULL;
		m_nLen = 0;
	}
	else
	{
		m_nLen = len;
		m_pData = new unsigned char[m_nLen];
		memcpy(m_pData, pData, m_nLen);
	}
}

Yk_Bytes::Yk_Bytes(unsigned int len, const unsigned char* pData)
{
	if (pData == NULL)
	{
		m_pData = NULL;
		m_nLen = 0;
	}
	else
	{
		m_nLen = len;
		m_pData = new unsigned char[m_nLen];
		memcpy(m_pData,pData,m_nLen);
	}
}

Yk_Bytes::Yk_Bytes(const Yk_Bytes& other)
{
	if (other.m_pData == NULL)
	{
		m_pData = NULL;
		m_nLen = 0;
	}
	else
	{
		m_nLen = other.m_nLen;
		m_pData = new unsigned char[other.m_nLen];
		memcpy(m_pData, other.m_pData, m_nLen);
	}
}

Yk_Bytes& Yk_Bytes::operator=(const Yk_Bytes& other)
{
	if (this!=&other)
	{
        
		delete[] m_pData;
        
		if (other.m_pData == NULL)
		{
			m_pData = NULL;
			m_nLen = 0;
		}
		else
		{
			m_nLen=other.m_nLen;
			m_pData = new unsigned char[other.m_nLen];
			memcpy(m_pData, other.m_pData, m_nLen);
		}
	}
    
	return *this;
}

Yk_Bytes Yk_Bytes::operator+(const Yk_Bytes& other) const
{
	Yk_Bytes newYk_Bytes;
    
	if (other.m_pData==NULL)
	{
		newYk_Bytes = *this;
	}
	else if (m_pData==NULL)
	{
		newYk_Bytes = other;
	}		
	else
	{
		newYk_Bytes.m_nLen = m_nLen+other.m_nLen;
		newYk_Bytes.m_pData = new unsigned char[newYk_Bytes.m_nLen];
		memcpy(newYk_Bytes.m_pData,m_pData,m_nLen);
		memcpy(newYk_Bytes.m_pData+m_nLen,other.m_pData,other.m_nLen);
	}
    
	return newYk_Bytes;
}

bool Yk_Bytes::operator==(const Yk_Bytes& s)     
{
	if ( s.m_nLen != m_nLen)
	{
		return false;
	}
    
	return memcmp(m_pData,s.m_pData,m_nLen)?false:true;
}

unsigned char &Yk_Bytes::operator[](unsigned int e)
{
	if (e<m_nLen)
	{
		return m_pData[e];
	}
	assert(0);
}

unsigned int Yk_Bytes::length()
{
	return m_nLen;
}




