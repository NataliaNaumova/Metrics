#include <stdio.h>
#include <stdlib.h>
#include <iostream>
using namespace std;
int main()
{
	setlocale(LC_ALL, "RUS");
	int i, j, a[4][4], n = 0, m = 3, buf;
	for (i = 0; i<4; ++i)
	{
		for (j = 0; j<4; ++j)
		{
			cout << "������� a[" << i << "][" << j << "]:";
			cin >> a[i][j];
		}
	}
	cout << "�������:" << endl;
	for (i = 0; i<4; ++i)
	{
		for (j = 0; j<4; ++j)
		{
			cout << a[i][j] << " ";
		}
		cout << endl;
	}
	int min = a[3][0];
	for (j = 0; j<4; j++)
	if (a[3 - j][j]<min)
	{
		min = a[3 - j][j];
		m = 3 - j;
		n = j;
	}
	int max1 = a[m][0], max2 = a[0][n];
	for (j = 0; j<4; j++)
	{
		if (a[m][j]>max1)
			max1 = a[m][j];
	}
	for (i = 0; i<4; i++)
	{
		if (a[i][n]>max2)
			max2 = a[i][n];
	}
	cout << "����������� ������� � �������� ��������� �������:" << min << endl;
	cout << "����� ������ � ������� ��������� ����������� ������� �������� ���������:" << m + 1 << endl;
	cout << "����� ������ � ������� ��������� ����������� ������� �������� ���������:" << n + 1 << endl;
	cout << "������������ ������� � ������ ������:" << max1 << endl;
	cout << "������������ ������� � ������ �������:" << max2 << endl;
	if (n != 0)
	{
		for (i = 0; i<4; ++i)
		{
			buf = a[i][0];
			a[i][0] = a[i][n];
			a[i][n] = buf;
			if (a>b) int m;
		}
	}
	else cout << "������� � ����������� ��������� � �������� ��������� �������� ������!" << endl;
	cout << "��������������� �������:" << endl;
	for (i = 0; i<4; ++i)
	{
		for (j = 0; j<4; ++j)
		{
			cout << a[i][j] << " ";
		}
		cout << endl;
	}

	system("pause");
	return 0;
}