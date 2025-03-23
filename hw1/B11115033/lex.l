%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENG 1024
#define LIST strcat(buf , yytext)
#define token(t) {LIST; printf("<%s>\n",t);}
#define tokenInteger(t,i) {LIST; printf("<%s:%d>\n",t,i);}
#define tokenString(t,s) {printf("<%s:%s>\n",t,s);}


char buf[MAX_LINE_LENG];
int  line_num = 0;

typedef struct SymbolEntry{
    char* key;
    int index;
    struct SymbolEntry* next;
} SymbolEntry;

typedef struct {
    SymbolEntry **table;
    int size;
    int count;
} SymbolTable;

SymbolTable *st = NULL;

unsigned int hash_function(const char *s){
    unsigned int h = 0;
    while(*s){
        h = (h << 4) + *s++;
      }
      return h % st->size;
  }

void create(){
  st = (SymbolTable*)malloc(sizeof(SymbolTable));
  st->size = 100;
  st->count = 0;
  st->table = (SymbolEntry**)calloc(st->size, sizeof(SymbolEntry*));
}

int lookup(const char *key){
  unsigned int h = hash_function(key);
  SymbolEntry *e = st->table[h];
  while(e){
    if(strcmp(e->key , key) == 0){
      return e->index;
    }
    e = e->next;
  }
  return -1;
}

int insert(const char *key){
  if(lookup(key) != -1){
      return -1;
  }
  SymbolEntry *new_entry = (SymbolEntry*)malloc(sizeof(SymbolEntry));
  unsigned int h = hash_function(key);
  new_entry->key = strdup(key);
  new_entry->index = st->count++;
  new_entry->next = st->table[h];
  st->table[h] = new_entry;
  return new_entry->index;
}

void dump(){
  printf("Symbol Table:\n"); 
  for(int i = 0 ; i < st->size ; i++){
    SymbolEntry *e = st->table[i];
    while(e){
        printf("%s\n" , e->key);
        e = e->next;
    }
  }
}

char* process_string(const char *input) {
    char *result = malloc(strlen(input) + 1);  
    int j = 0;
    for (int i = 1; input[i + 1] != '\0'; i++) { 
        if (input[i] == '"' && input[i + 1] == '"') {
            result[j++] = '"';  
            i++;  
        } else {
            result[j++] = input[i];
        }
    }
    result[j] = '\0';
    return result;
}

%}

%x C_COMMENT
%x CPP_COMMENT

%%

"." { token("'.'"); } 
"," { token("','"); }
":" { token("':'"); }
";" { token("';'"); }
"(" { token("'('"); }
")" { token("')'"); }
"[" { token("'['"); }
"]" { token("']'"); }
"{" { token("'{'"); }
"}" { token("'}'"); }

"+" { token("'+'"); }
"++" { token("'++'"); }
"-" { token("'-'"); }
"--" { token("'--'"); }
"*" { token("'*'"); }
"/" { token("'/'"); }
"%" { token("'%'"); }
"=" { token("'='"); }
"<" { token("'<'"); }
"<=" { token("'<='"); }
">=" { token("'>='"); }
">" { token("'>'"); }
"==" { token("'=='"); }
"!=" { token("'!='"); }
"&&" { token("'&&'"); }
"||" { token("'||'"); }
"!" { token("'!'"); }

"bool" { token("BOOL"); }
"break" { token("BREAK"); }
"case" { token("CASE"); }
"char" { token("CHAR"); }
"const" { token("CONST"); }
"continue" { token("CONTINUE"); }
"default" { token("DEFAULT"); }
"do" { token("DO"); }
"double" { token("DOUBLE"); }
"else" { token("ELSE"); }
"extern" { token("EXTERN"); }
"fale" { token("FALSE"); }
"float" { token("FLOAT"); }
"for" { token("FOR"); }
"foreach" { token("FOREACH"); }
"if" { token("IF"); }
"int" { token("INT"); }
"print" { token("PRINT"); }
"println" { token("PRINTLN"); }
"read" { token("READ"); }
"return" { token("RETURN"); }
"string" { token("STRING"); }
"switch" { token("SWITCH"); }
"true" { token("TRUE"); }
"void" { token("VOID"); }
"while" { token("WHILE"); }

[0-9]+ { 
  tokenInteger("integer", atoi(yytext));
  }

[+-]?[0-9]*\.[0-9]+([eE][+-]?[0-9]+)? {
   LIST;
   tokenString("real", yytext);
  }

[a-zA-Z][a-zA-Z0-9]* { 
  LIST;
  insert(yytext);
  tokenString("ID", yytext);
  } 

\"([^"]|\"\")*\"    {
  LIST;  
  char *processed = process_string(yytext);  
  tokenString("string", processed);  
  free(processed);  
  }

[ \t]+ { LIST; } 

"/*" {
  LIST; 
  BEGIN(C_COMMENT);
  }
<C_COMMENT>. {LIST;}
<C_COMMENT>\n { 
  LIST;
  line_num++;
  printf("%d: %s", line_num, buf);
  buf[0] = '\0';
  }
<C_COMMENT>"*/" {
  LIST;
  BEGIN(INITIAL);
  }

"//" {LIST;BEGIN(CPP_COMMENT);}
<CPP_COMMENT>. {LIST;}
<CPP_COMMENT>\n {
  LIST;
  line_num++;
  printf("%d: %s", line_num, buf);
  buf[0] = '\0';
  BEGIN(INITIAL);
  }


\n {
  line_num++;
  printf("%d: %s\n", line_num, buf);
  buf[0] = '\0';
  } 

%%



int main(void){
    char sFile[1024];
    printf("Enter the file name: ");
    scanf("%s", sFile);
    FILE* fp = fopen(sFile, "r");
    if (fp == NULL) {
        printf("Cannot open %s\n", sFile);
        return -1;
    }
    yyin = fp;
    create();
    yylex();
    printf("\n");
    dump();
    return 0;
  }
