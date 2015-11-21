#include<stdio.h>
#include<locale.h>
#include<stdlib.h>
#include <iostream>
#include<time.h>
using namespace std;
void main()
{
	setlocale(LC_ALL, "russian");
	int A[5][7], B[3][6], i, j, m1=0,n1=0,m2=0,n2=0,buf;
	srand(time(NULL));
	for (i = 0; i < 5; i++)
	{
		for (j = 0; j < 7; j++)
		{
			A[i][j] = rand() % 100 + 1;
		}
	}
	for (i = 0; i < 3; i++)
	{
		for (j = 0; j < 6; j++)
		{
			B[i][j] = rand() % 100 + 1;
		}
	}
	cout << "Массив 1:" << endl;
	for (i = 0; i < 5; ++i)
	{
		for (j = 0; j < 7; ++j)
		{
			cout << A[i][j] << "\t";
		}
		cout << endl;
	}
	cout << "Массив 2:" << endl;
	for (i = 0; i < 3; ++i)
	{
		for (j = 0; j < 6; ++j)
		{
			cout << B[i][j] << "\t";
		}
		cout << endl;
	}
	int maxA = A[0][0];
	for (i = 0; i < 5; ++i)
	{
		for (j = 0; j < 7; ++j)
		{
			if (A[i][j]>maxA)
			{
				maxA = A[i][j];
				m1 = i;
				n1 = j;
			}
		}
	}
	int minB = B[0][0];
	for (i = 0; i < 3; ++i)
	{
		for (j = 0; j < 6; ++j)
		{
			if (B[i][j] < minB)
			{
				minB = B[i][j];
				m2 = i;
				n2 = j;
			}
		}
	}
	cout << "Максимальный элемент в массиве А: " << maxA << endl;
	cout << "Максимальный элемент в массиве A находится в строке: " << m1 + 1 << endl;
	cout << "Максимальный элемент в массиве A находится в столбце: " << n1 + 1 << endl;
	cout << "Минимальный элемент в массиве B: " << minB << endl;
	cout << "Минимальный элемент в массиве B находится в строке: " << m2 + 1 << endl;
	cout << "Минимальный элемент в массиве B находится в столбце: " << n2 + 1 << endl;
	if (A[m1][n1] > B[m2][n2])
	{
		buf = A[m1][n1];
		A[m1][n1] = B[m2][n2];
		B[m2][n2] = buf;
	}
	else cout << "Максимальный элемент массива А меньше минимального элемента массива В!" << endl;
	cout << "Полученные массивы:" << endl;
	cout << "Массив 1:" << endl;
	for (i = 0; i < 5; ++i)
	{
		for (j = 0; j < 7; ++j)
		{
			cout << A[i][j] << "\t";
		}
		cout << endl;
	}
	cout << "Массив 2:" << endl;
	for (i = 0; i < 3; ++i)
	{
		for (j = 0; j < 6; ++j)
		{
			cout << B[i][j] << "\t";
		}
		cout << endl;
	}
	FILE *TEXT;
	errno_t error;
	error = fopen_s(&TEXT, "text.txt", "r");

	char tempSymbol;
	int elementCount = 0;
	while (!(feof(TEXT)))
	{
		fread(&tempSymbol,sizeof(char),1,TEXT);
		pushtoStack(&topStackElement1, tempSymbol);
		elementCount++;
	}
	popfromStack(&topStackElement1);
	elementCount--;

	int i = 1;
	while (i <= (elementCount / 2))
	{
		pushtoStack(&topStackElement2, popfromStack(&topStackElement1));
		i++;
	}

	int TextIsSymmetrical = 1;
	i = 1;
	if (elementCount % 2 == 1)
		popfromStack(&topStackElement1);
	while ((i <= (elementCount / 2)) && (TextIsSymmetrical != 0))
	{
		if (popfromStack(&topStackElement1) != popfromStack(&topStackElement2))
			TextIsSymmetrical = 0;
		i++;
	}
	
	if (TextIsSymmetrical == 1)
		printf("Text is symmetrical");
	else
		printf("Text is not symmetrical");
	
	
	switch (a)
	{
		case 'A':
			if (a>b) b = a;
			break;
		case 'B':
			if (a==b) a = b;
			break;
		default:
			a = '0';
			b = '0';
	}

	cout << "Максимальный элемент в массиве А: " << maxA << endl;
	cout << "Максимальный элемент в массиве A находится в строке: " << m1 + 1 << endl;
	cout << "Максимальный элемент в массиве A находится в столбце: " << n1 + 1 << endl;
	cout << "Минимальный элемент в массиве B: " << minB << endl;
	cout << "Минимальный элемент в массиве B находится в строке: " << m2 + 1 << endl;
	cout << "Минимальный элемент в массиве B находится в столбце: " << n2 + 1 << endl;

	if (A[i][j]>maxA) a = b;

	char str[20];
	printf("Enter word\n");
	gets_s(str);
	printf("\n");


	char PrevLett;
	char strbuf[20];
	int k;
	int i;
	int j;


	PrevLett = str[0];
	i = 1;

	if (str[i] == PrevLett)
		printf("%c", '_');
	else
		printf("%c", str[i - 1]);


	if (str[i] != '\0')
		i = 1;
	else
		str[0] = '\0';

	char PrevLett;
	char strbuf[20];
	int k;
	int i;
	int j;


	PrevLett = str[0];
	i = 1;

	if (str[i] == PrevLett)
		printf("%c", '_');
	else
		printf("%c", str[i - 1]);


	if (str[i] != '\0')
		i = 1;
	else
		str[0] = '\0';
	
}