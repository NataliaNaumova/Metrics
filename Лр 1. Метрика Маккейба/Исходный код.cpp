#include <stdlib.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
struct FILM
{
	char FilmName[10];
	char FilmType[10];
	int Year;
};

void clean_stdin()
{
	int c;
	do
	{
		c = getchar();
	} while (c != '\n' && c != EOF);
}

char* AllocMem_char(int StringLength)
{
	char *ss;
	ss = (char*)calloc(StringLength, sizeof (char));
	return ss;
}

int enter_num(int LowerLimit, int UpperLimit)
{
	int prov, symbol;
	do
	{
		prov = scanf("%d", &symbol);
	} while (prov != 1 || symbol < LowerLimit || symbol > UpperLimit);
	return symbol;
}

int MENU()
{
	int PointMenu;
	printf("\n1. New file.");
	printf("\n2. See file");
	printf("\n3. Add in to file");
	printf("\n4. Search and edit");
	printf("\n0. Quit");
	printf("\nYour choise - ");
	PointMenu = enter_num(0, 4);
	return PointMenu;
}

struct FILM
{
	char FilmName[10];
	char FilmType[10];
	int Year;
};

void clean_stdin()
{
	int c;
	do
	{
		c = getchar();
	} while (c != '\n' && c != EOF);
}

char* AllocMem_char(int StringLength)
{
	char *ss;
	ss = (char*)calloc(StringLength, sizeof (char));
	return ss;
}

int enter_num(int LowerLimit, int UpperLimit)
{
	int prov, symbol;
	do
	{
		prov = scanf("%d", &symbol);
	} while (prov != 1 || symbol < LowerLimit || symbol > UpperLimit);
	return symbol;
}

int MENU()
{
	int PointMenu;
	printf("\n1. New file.");
	printf("\n2. See file");
	printf("\n3. Add in to file");
	printf("\n4. Search and edit");
	printf("\n0. Quit");
	printf("\nYour choise - ");
	PointMenu = enter_num(0, 4);
	return PointMenu;
}

int main()
{
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
			printf("%c", str[i-1]);


		if (str[i] != '\0')
				i=1;
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
			printf("%c", str[i-1]);


		if (str[i] != '\0')
				i=1;
		else
			str[0] = '\0';

	getch();

}

