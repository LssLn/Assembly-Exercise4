int elabora(char *st){
     int i,conta;
     conta=0;
     for(i=0;i<8;i++)
         conta=conta+st[i]-97 ;
     return conta;
}
main() {
     char ST[16];
     int i, num;
     for(i=0;i<3;i++){
         printf("Inserisci una str con 8 lettere minuscole\n");
         scanf("%s",ST);
         if(strlen(ST)==8){
             num=elabora(ST);
             printf("Numero= %d\ n",num);
         }
     }
}
