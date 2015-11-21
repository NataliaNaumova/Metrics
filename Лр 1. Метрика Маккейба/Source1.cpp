#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
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

void input(FILE *file, char* fname, FILM &ss)
{
	char symbol;
	file = fopen(fname, "wb");
	printf("\nEnter information on the film");
	do
	{
		printf("\nThe name: ");
		clean_stdin();
		scanf("%s", ss.FilmName);

		printf("\nThe type: ");
		clean_stdin();
		scanf("%s", ss.FilmType);
		printf("\nYear: ");
		ss.Year = enter_num(0, 2016);

		fwrite(&ss, sizeof(ss), 1, file);
		printf("\nAre tou finishing?  (y/n) \n");
		clean_stdin();
		scanf("%c", &symbol);
	} while (symbol != 'y');
	fclose(file);
}

int countZapisei(char *fname)
{
	FILM ss;
	FILE *file;
	int count = 0;
	file = fopen(fname, "rb");

	while (!feof(file))
	{
		fread(&ss, sizeof(ss), 1, file);
		count++;
	}
	fclose(file);
	return --count;
}

void print(FILE *file, char* fname)
{
	int i = 0, kolStr;
	int kol = 0;
	FILM ss;
	file = fopen(fname, "rb");

	kolStr = countZapisei(fname);

	while (!feof(file))
	{
		if (i < kolStr) i++;
		else break;
		fread(&ss, sizeof(ss), 1, file);
		if (ss.Year == 0)
			continue;
		kol++;
		printf("\nNumber: %d, Name:  %s, Type: %s, Year: %d.", kol, ss.FilmName, ss.FilmType, ss.Year);
	}
	fclose(file);
}

void app(FILE *file, char *fname, FILM &ss)
{
	file = fopen(fname, "ab");
	char symbol;
	printf("\nEnter films \n");
	do
	{
		printf("\nThe name: ");
		clean_stdin();
		scanf("%s", ss.FilmName);
		printf("\nThe type: ");
		clean_stdin();
		scanf("%s", ss.FilmType);
		printf("\nYear: ");
		clean_stdin();
		scanf("%d", &ss.Year);
		fwrite(&ss, sizeof(ss), 1, file);
		printf("\nAre you finishing?  (y/n) ");
		clean_stdin();
		scanf("%c", &symbol);
	} while (symbol != 'y');
	fclose(file);
}

void FindFilmsName(FILE *file, char *fname, int countStr)
{
	char input[10], symbol;
	int i = 0;
	bool FindStruct = false;
	FILM *ss = (FILM*)calloc(countStr, sizeof(FILM));
	print(file, fname);
	file = fopen(fname, "rb+");
	fread(ss, sizeof(FILM), countStr, file);
	printf("\nEnter for search the name of film - ");
	clean_stdin();
	scanf("%s", input);
	for (int i = 0; i < countStr; i++)
	{
		if (strcmp(ss[i].FilmName, input) == 0)
		{
			FindStruct = true;
			printf("\nNumber: %d; Name:  %s; Type: %s; Year: %d", i + 1, ss[i].FilmName, ss[i].FilmType, ss[i].Year);
			printf("\n Edit? y/n ");
			clean_stdin();
			scanf("%c", &symbol);
			if (symbol == 'y')
			{
				printf("\nIf you want delete, enter  D.");
				clean_stdin();
				scanf("%c", &symbol);
				if (symbol == 'd')
				{
					int count = 0;
					for (int k = i; k < countStr; k++)
					{
						ss[k] = ss[k + 1];
						count++;
					}
					for (int k = 0; k < count; k++)
					{
						ss[countStr - 1].Year = 0;
						ss[countStr - 1].FilmType[0] = '\0';
						ss[countStr - 1].FilmName[0] = '\0';
					}
					break;
				}
				printf("\nThe name - ");
				clean_stdin();
				scanf("%s", ss[i].FilmName);
				printf("\nThe type - ");
				clean_stdin();
				scanf("%s", ss[i].FilmType);
				printf("\nYear - ");
				clean_stdin();
				scanf("%d", &ss[i].Year);
			}
		}
	}
	rewind(file);
	for (int i = 0; i < countStr; i++)
		fwrite(&ss[i], sizeof(ss[i]), 1, file);
	if (FindStruct == false)
		printf("There is not found");
	fclose(file);
	print(file, fname);
}

void FindFilmsType(FILE *file, char *fname, int countStr)
{
	char input[10];
	int i = 0;
	bool FindStruct = false;
	FILM *ss = (FILM*)calloc(countStr, sizeof(FILM));
	file = fopen(fname, "rb+");
	char symbol;
	fread(ss, sizeof(FILM), countStr, file);
	printf("\nFor search enter the type of films - ");
	clean_stdin();
	scanf("%s", input);
	for (int i = 0; i < countStr; i++)
	{
		if (strcmp(ss[i].FilmType, input) == 0)
		{
			FindStruct = true;
			printf("Number: %d; Name:  %s; Type: %s; Year: %d", i + 1, ss[i].FilmName, ss[i].FilmType, ss[i].Year);
			printf("\nEdit? y/n \n");
			clean_stdin();
			scanf("%c", &symbol);
			if (symbol == 'y')
			{
				printf("\nThe name - ");
				fflush(stdin);
				scanf("%s", ss[i].FilmName);
				printf("\nThe type - ");
				fflush(stdin);
				scanf("%s", ss[i].FilmType);
				printf("\nYear - ");
				fflush(stdin);
				scanf("%d", &ss[i].Year);
			}
		}
	}
	rewind(file);
	for (int i = 0; i < countStr; i++)
		fwrite(&ss[i], sizeof(ss[i]), 1, file);
	if (FindStruct == false)
		printf("There is not found.\n");
	fclose(file);
}

void findAll(FILE *file, char *fname)
{
	int choise;
	printf("\nSEARCH:");
	printf("\n1. The name\n2. The type\n\nYour choice - ");
	choise = enter_num(1, 2);
	if (choise == 1) FindFilmsName(file, fname, countZapisei(fname));
	if (choise == 2) FindFilmsType(file, fname, countZapisei(fname));
}

void print(char *name)
{
	FILE* file;
	int k = 0;
	FILM ss;
	if ((file = fopen(name, "rb")) == NULL)
	{
		puts("Error\n");
		return;
	}
	puts("Film type year");
	do
	{
		k++;
		fread(&ss, sizeof(FILM), 1, file);
		if (feof(file)) break;
		if (k >= 10)
		{
			k = 0;
			fflush(stdin);
			puts("Film type year");
		}
		printf("\n %s %s %d", ss.FilmName, ss.FilmType, ss.Year);
	} while (!feof(file));
	fclose(file);
}

int main()
{
	FILE *file;
	FILM films;
	char symbol;
	int PointMenu;
	char *fname;
	//fname = argv[1];
	fname = "file.txt";
	if (!(file = fopen(fname, "rb")))
	{
		printf("The file %s is not found.\n", fname);
		return 0;
	}
	do
	{
		PointMenu = MENU();
		switch (PointMenu)
		{
		case 1:
			input(file, fname, films);
			break;
		case 2:
			print(file, fname);
			break;
		case 3:
			app(file, fname, films);
			break;
		case 4:
			findAll(file, fname);
			break;
		case 0:
			fclose(file);
			return 0;
		}
		printf("\nDo you want to do any more actions?(y/n)");
		clean_stdin();
		scanf("%c", &symbol);
	} while (symbol == 'y');
	fclose(file);
	return 0;
}