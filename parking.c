#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/time.h>

/* Inserite eventuali extern modules qui */

/* ************************************* */

enum { MAXLINES = 200 };
enum { LIN_LEN = 5 };
enum { LOUT_LEN = 15 };

long long current_timestamp() {
    struct timespec tp;
	clock_gettime(CLOCK_REALTIME, &tp);
	/* te.tv_nsec nanoseconds divide by 1000 to get microseconds*/
	long long nanoseconds = tp.tv_sec*1000LL + tp.tv_nsec; // caculate nanoseconds
    return nanoseconds;
}


int main(int argc, char *argv[]) {
    int i = 0;
    char bufferin[MAXLINES*LIN_LEN+1] ;
    char line[1024];
    long long tic_c, toc_c, tic_asm, toc_asm;

    char bufferout_c[MAXLINES*LOUT_LEN+1] = "" ;
    char bufferout_asm[MAXLINES*LOUT_LEN+1] = "" ;

    FILE *inputFile = fopen(argv[1], "r");

    if(argc != 3)
    {
        fprintf(stderr, "Syntax ./test <input_file> <output_file>\n");
        exit(1);
    }

    if (inputFile == 0)
    {
        fprintf(stderr, "failed to open the input file. Syntax ./test <input_file> <output_file>\n");
        exit(1);
    }

    while (i < MAXLINES && fgets(line, sizeof(line), inputFile))
    {
        i = i + 1;
        strcat( bufferin, line) ;
    }

    bufferin[MAXLINES*LIN_LEN] = '\0' ;

    fclose(inputFile);


    /* ELABORAZIONE in C */
    tic_c = current_timestamp();

    /* è possibile inserire qui il codice per l'elaborazione in C (non richiesto per l'elaborato) */
    /* questo pezzo di codice è solo una base di partenza per fare dei check sui dati */
    
    
    int c = 0;
    while ( bufferin[c] != '\0') {
      printf( "%c", bufferin[c] );
      // strncat( bufferout_asm, &bufferin[c], 1);
      c = c + 1 ;
    }
    
    char sa_char[3];
    char sb_char[3];
    char sc_char[3];

    // posti in a
    c = 0;
    int n = 0;
    while (bufferin[c] != '\0') {
      if (bufferin[c] == 'A') {
        if (bufferin[c+1] == 45) {
          c += 2;
          while (bufferin[c] != 10) {
            sa_char[n] = bufferin[c];
            c++;
            n++;
          }
        }
      }
      c++;
    }

    // posti in b
    c = 0;
    n = 0;
    while (bufferin[c] != '\0') {
      if (bufferin[c] == 'B') {
        if (bufferin[c+1] == 45) {
          c += 2;
          while (bufferin[c] != 10) {
            sb_char[n] = bufferin[c];
            c++;
            n++;
          }
        }
      }
      c++;
    }

    // posti in c
    c = 0;
    n = 0;
    while (bufferin[c] != '\0') {
      if (bufferin[c] == 'C') {
        if (bufferin[c+1] == 45) {
          c += 2;
          while (bufferin[c] != 10) {
            sc_char[n] = bufferin[c];
            c++;
            n++;
          }
        }
      }
      c++;
    }
    
    // convertire array in interi
    int sa = atoi(sa_char);
    int sb = atoi(sb_char);
    int sc = atoi(sc_char);
    int sa_max = 31;
    int sb_max = 31;
    int sc_max = 24;
    int min = 0;
    char res[15];
    res[2] = '-';
    res[5] = '-';
    res[8] = '-';
    res[11] = '-';

    
    // ora devo valutare le direttive dalla quarta riga.
    // nota: il linguaggio C offre strumenti ben più eleganti
    // per fare la stessa cosa, uso una catena di if per coerenza
    // con il blocco assembly.

    // Questo codice non funziona perfettamente. Entra dove dovrebbe
    // ma non stampa i CC
    // perché per ora OC CO sono hardcodati (questo non va bene).
    c = 0;
    while (bufferin[c] != '\0') {
      if (bufferin[c] == 'I') {
        if (bufferin[c+1] == 'N') {
          if (bufferin[c+2] == '-') {
            if (bufferin[c+3] == 'A') {
              // IN-A
              printf("ENTRO IN A\n");
              if ((sa + 1) <= sa_max) {
                sa++;
                // OC-19-29-07-000
                sprintf(sa_char,"%d",sa);
                sprintf(sb_char,"%d",sb);
                sprintf(sc_char,"%d",sc);
                strcat(bufferout_asm, "OC-");
                if (sa < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sa_char);
                strcat(bufferout_asm, "-");
                if (sb < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sb_char);
                strcat(bufferout_asm, "-");
                if (sc < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sc_char);
                strcat(bufferout_asm, "-");
                strcat(bufferout_asm, "0");
                if (sb >= sb_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                if (sc >= sc_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, "\n");
              }
            }
            if (bufferin[c+3] == 'B') {
              // IN-B
              printf("ENTRO IN B\n");
              if ((sb+1) <= sb_max) {
                sb++;
                sprintf(sa_char,"%d",sa);
                sprintf(sb_char,"%d",sb);
                sprintf(sc_char,"%d",sc);
                strcat(bufferout_asm, "OC-");
                if (sa < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sa_char);
                strcat(bufferout_asm, "-");
                if (sb < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sb_char);
                strcat(bufferout_asm, "-");
                if (sc < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sc_char);
                strcat(bufferout_asm, "-");
                strcat(bufferout_asm, "0");
                if (sb >= sb_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                if (sc >= sc_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, "\n");
              }
            }
            if (bufferin[c+4] == 'C') {
              // IN-C
              printf("ENTRO IN C\n");
              if ((sc+1) <= sc_max) {
                sc++;
                sprintf(sa_char,"%d",sa);
                sprintf(sb_char,"%d",sb);
                sprintf(sc_char,"%d",sc);
                strcat(bufferout_asm, "OC-");
                if (sa < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sa_char);
                strcat(bufferout_asm, "-");
                if (sb < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sb_char);
                strcat(bufferout_asm, "-");
                if (sc < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sc_char);
                strcat(bufferout_asm, "-");
                strcat(bufferout_asm, "0");
                if (sb >= sb_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                if (sc >= sc_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, "\n");
              }
            }
          }
        }
      }
      if (bufferin[c] == 'O') {
        if (bufferin[c+1] == 'U') {
          if (bufferin[c+2] == 'T') {
            if (bufferin[c+3] == '-') {
              if (bufferin[c+4] == 'A') {
                // OUT-A
                printf("ESCO DA A\n");
                if ((sa-1) >= 0) {
                  sa--;
                  sprintf(sa_char,"%d",sa);
                sprintf(sb_char,"%d",sb);
                sprintf(sc_char,"%d",sc);
                strcat(bufferout_asm, "CO-");
                if (sa < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sa_char);
                strcat(bufferout_asm, "-");
                if (sb < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sb_char);
                strcat(bufferout_asm, "-");
                if (sc < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sc_char);
                strcat(bufferout_asm, "-");
                strcat(bufferout_asm, "0");
                if (sb >= sb_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                if (sc >= sc_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, "\n");
                }
              }
              if (bufferin[c+4] == 'B') {
                // OUT-B
                printf("ESCO DA B\n");
                if ((sb-1) >= 0) {
                  sb--;
                sprintf(sa_char,"%d",sa);
                sprintf(sb_char,"%d",sb);
                sprintf(sc_char,"%d",sc);
                strcat(bufferout_asm, "CO-");
                if (sa < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sa_char);
                strcat(bufferout_asm, "-");
                if (sb < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sb_char);
                strcat(bufferout_asm, "-");
                if (sc < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sc_char);
                strcat(bufferout_asm, "-");
                strcat(bufferout_asm, "0");
                if (sb >= sb_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                if (sc >= sc_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, "\n");
                }
              }
              if (bufferin[c+4] == 'C') {
                // OUT-C
                printf("ESCO DA C\n");
                if ((sc-1) >= 0) {
                  sc--;
                  sprintf(sa_char,"%d",sa);
                sprintf(sb_char,"%d",sb);
                sprintf(sc_char,"%d",sc);
                strcat(bufferout_asm, "CO-");
                if (sa < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sa_char);
                strcat(bufferout_asm, "-");
                if (sb < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sb_char);
                strcat(bufferout_asm, "-");
                if (sc < 10)
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, sc_char);
                strcat(bufferout_asm, "-");
                strcat(bufferout_asm, "0");
                if (sb >= sb_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                if (sc >= sc_max)
                  strcat(bufferout_asm, "1");
                else
                  strcat(bufferout_asm, "0");
                strcat(bufferout_asm, "\n");
                }
              }
            }
          }
        }
      }
      c++;
    }

    printf("TEST\n");
    c = 0;
    while (bufferout_asm[c] != '\0') {
      printf("%c", bufferout_asm[c]);
      c++;
    }

    toc_c = current_timestamp();

  	long long c_time_in_nanos = toc_c - tic_c;

    /* FINE ELABORAZIONE C */


    /* INIZIO ELABORAZIONE ASM */

    tic_asm = current_timestamp();

    /* Assembly inline:
    Inserite qui il vostro blocco di codice assembly inline o richiamo a funzioni assembly.
    Il blocco di codice prende come input 'bufferin' e deve restituire una variabile stringa 'bufferout_asm' che verrà poi salvata su file. */


    toc_asm = current_timestamp();

  	long long asm_time_in_nanos = toc_asm - tic_asm;

    /* FINE ELABORAZIONE ASM */


    printf("C time elapsed: %lld ns\n", c_time_in_nanos);
    printf("ASM time elapsed: %lld ns\n", asm_time_in_nanos);

    /* Salvataggio dei risultati ASM */
  	FILE *outputFile;
    outputFile = fopen (argv[2], "w");
    fprintf (outputFile, "%s", bufferout_asm);
    fclose (outputFile);

    return 0;
}
