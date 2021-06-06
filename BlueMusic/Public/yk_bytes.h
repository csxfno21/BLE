#ifndef YK_BYTES_H
#define  YK_BYTES_H

class Yk_Bytes
{
public:
	Yk_Bytes();
	Yk_Bytes(unsigned int len);
	Yk_Bytes(unsigned int len, const char* pData);
	Yk_Bytes(unsigned int len, const unsigned char* pData);       
    
	Yk_Bytes(const Yk_Bytes& other);                 //赋值构造函数
    
	unsigned char* GetBuffer() const {
        return m_pData;
    };
	Yk_Bytes& operator = (const Yk_Bytes& other);       //operator=
    
	Yk_Bytes operator + (const Yk_Bytes& other)const;  //operator+
    
	bool operator == (const Yk_Bytes&);              //operator==
    
	unsigned char &operator[](unsigned int);              //operator[]
    
	unsigned int length();
    
	virtual ~Yk_Bytes(void);
private:
	unsigned char* m_pData;
	unsigned int m_nLen;
};

#endif
