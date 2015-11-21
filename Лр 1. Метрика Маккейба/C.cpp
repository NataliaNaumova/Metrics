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
			cout << "Введите a[" << i << "][" << j << "]:";
			cin >> a[i][j];
		}
	}
	cout << "Матрица:" << endl;
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
	cout << "Минимальный элемент в побочной диагонале матрицы:" << min << endl;
	cout << "Номер строки в которой находится минимальный элемент побочной диагонали:" << m + 1 << endl;
	cout << "Номер стобца в котором находится минимальный элемент побочной диагонали:" << n + 1 << endl;
	cout << "Максимальный элемент в данной строке:" << max1 << endl;
	cout << "Максимальный элемент в данном столбце:" << max2 << endl;
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
	else cout << "Столбец с минимальным элементом в побочной диагонале является первым!" << endl;
	cout << "Преобразованная матрица:" << endl;
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