       IDENTIFICATION DIVISION.                                         
       PROGRAM-ID. CIOCCA00.                                            
      ***************************************************************** 
      * CIOCCIMN - CLIENT PROGRAM                                       
      *                                                                 
      * CREDIT ISSUANCE MAIN MENU                                       
      *                                                                 
      ***************************************************************** 
      *                         VERSION HISTORY                         
      *---------------------------------------------------------------- 
      *DATE/TIME    AUTHOR    DESCRIPTION                            
      *---------------------------------------------------------------- 
      *2015-01-06    KEVIN      INITIAL VERSION                         
      ***************************************************************** 
       ENVIRONMENT DIVISION.                                            
       DATA DIVISION.                                                   
       WORKING-STORAGE SECTION.                                         
      *                                                                 
       77 WS-BEGIN              PIC X(17) VALUE 'CIOCCAMN WS BEGIN'.    
       01 WS-VAR.                                                       
          05 WS-GETTIME         PIC X(20).                              
          05 WS-DATEOUT         PIC X(10).                              
          05 WS-TIMEOUT         PIC X(8).                               
          05 WS-RESP-CODE       PIC S9(8) COMP.                         
          05 WS-MESSAGE         PIC X(40).                              
          05 WS-ENTER-FLAG      PIC X(1).                               
          05 WS-TRANSID         PIC X(4).                               
       01 WS-MAP-OPTION         PIC X(1).                               
          88 WS-MAP-ERASE       VALUE '0'.                              
          88 WS-MAP-DATAONLY    VALUE '1'.                              
      *                                                                 
      *SCREEN HANDLER                                                   
       COPY SD11WS.                                                     
      * SYMBOLIC MAP                                                    
       COPY CICA00.                                                     
      *MAP CONTROL                                                      
       COPY DFHBMSCA.                                                   
      *CICS FUNCTION KEYS                                               
       COPY DFHAID.                                                     
      *CIMENU                                                           
       COPY CIMENU.                                                     
      *                                                                 
       01 WS-SRV-COMMAREA.                                              
      *SERVICE REQUEST/RESPONSE COMMAREA                                
       COPY SD01WS.                                                     
      *                                                                 
       01 WS-COMMAREA.                                                  
          05 WS-FIRST-SEND      PIC X(1).                               
          05 WS-OPTION          PIC 9(3).                               
       77 WS-END                PIC X(15) VALUE 'CIOCCAMN WS END'.      
      *                                                                 
       LINKAGE SECTION.                                                 
       01 DFHCOMMAREA.                                                  
      *COMMON CICS SCREEN HANDLE VARIABLES                              
       COPY SD00WS.                                                     
      *                                                                 
       PROCEDURE DIVISION.                                              
       0000-MAINLINE SECTION.                                                   
      *                                                                 
            PERFORM 1000-INIT                                           
               THRU 1000-INIT-EXIT                                      
      *                                                                 
            PERFORM 2000-PRE-PROCESSING                                 
               THRU 2000-PRE-PROCESSING-EXIT                            
      *                                                                 
            PERFORM 3000-MAIN-PROCESS                                   
               THRU 3000-MAIN-PROCESS-EXIT                              
      *                                                                 
            PERFORM 4000-POST-PROCESSING                                
               THRU 4000-POST-PROCESSING-EXIT                           
      *                                                                 
            PERFORM 5000-CLEAN-UP                                       
               THRU 5000-CLEAN-UP-EXIT                                  
            .                                                           
      *                                                                 
       0000-EXIT.                                                       
            EXIT.                                                       
      *                                                                 
       1000-INIT.                                                       
            IF EIBCALEN = 0                                             
               MOVE LOW-VALUES TO CICA00O                               
               SET WS-MAP-ERASE TO TRUE                                 
               PERFORM 3030-SEND-MAP                                    
                  THRU 3030-SEND-MAP-EXIT                               
      * NOT FIRST SHOW                                                  
            ELSE                                                        
               IF SDCA-CICS-SECONDENTER                                 
                  MOVE LOW-VALUES TO CICA00I                            
                  EXEC CICS RECEIVE MAP('CICA00')                       
                                   MAPSET('CICA00')                     
                                   INTO(CICA00I)                        
                                   RESP(WS-RESP-CODE)                   
                  END-EXEC                                              
               END-IF                                                   
            END-IF                                                      
            .                                                           
       1000-INIT-EXIT.                                                  
            EXIT.                                                       
      *                                                                 
       1010-ASK-TIME-DATE.                                              
      *                                                                 
            EXEC CICS                                                   
                 ASKTIME                                                
                 ABSTIME(WS-GETTIME)                                    
            END-EXEC                                                    
            EXEC CICS                                                   
                 FORMATTIME                                             
                 ABSTIME(WS-GETTIME)                                    
                 DATESEP('/')                                           
                 YYYYMMDD(WS-DATEOUT)                                   
            END-EXEC                                                    
            EXEC CICS                                                   
                 FORMATTIME                                             
                 ABSTIME(WS-GETTIME)                                    
                 TIMESEP                                                
                 TIME(WS-TIMEOUT)                                       
            END-EXEC                                                    
            MOVE WS-DATEOUT TO SYSDO                                    
            MOVE WS-TIMEOUT TO SYSTO                                    
            .                                                           
      *                                                                 
       1010-ASK-TIME-DATE-EXIT.                                         
            EXIT.                                                       
      *                                                                 
       2000-PRE-PROCESSING.                                             
      *                                                                 
       2000-PRE-PROCESSING-EXIT.                                        
            EXIT.                                                       
      *                                                                 
       3000-MAIN-PROCESS.*>IMPORTANT                                            
            EVALUATE EIBAID                                             
                WHEN DFHPF1                                             
                     EXEC CICS                                          
                          XCTL PROGRAM('CIOCCIMN')                      
                               RESP(WS-RESP-CODE)                       
                     END-EXEC                                           
                     IF WS-RESP-CODE NOT = DFHRESP(NORMAL)              
                        MOVE 'PROGRAM CIOCCIMN IS NOT AVAILABLE'        
                                TO MSGO                                 
                        SET WS-MAP-DATAONLY TO TRUE                     
                        PERFORM 3030-SEND-MAP THRU 3030-SEND-MAP-EXIT   
                     END-IF                                             
                WHEN DFHPF3                                             
                     MOVE 'THANK YOU FOR USING THE SYSTEM' TO WS-MESSAGE
                     EXEC CICS                                          
                          SEND CONTROL                                  
                          CURSOR                                        
                          ERASE                                         
                          FREEKB                                        
                          ALARM                                         
                     END-EXEC                                           
                     EXEC CICS                                          
                          SEND FROM(WS-MESSAGE)                         
                     END-EXEC                                           
                     PERFORM 5010-RETURN THRU 5010-RETURN-EXIT          
                WHEN DFHCLEAR                                           
                     EXEC CICS                                          
                           SEND CONTROL                                 
                           CURSOR                                       
                           ERASE                                        
                           FREEKB                                       
                           ALARM                                        
                     END-EXEC                                           
                     PERFORM 5010-RETURN THRU 5010-RETURN-EXIT          
                WHEN DFHPF9                                             
                     MOVE LOW-VALUES TO CICA00O                         
                     SET WS-MAP-ERASE TO TRUE                           
                     PERFORM 3030-SEND-MAP                              
                        THRU 3030-SEND-MAP-EXIT                         
                 WHEN DFHENTER                                          
                      IF WS-RESP-CODE NOT EQUAL DFHRESP(NORMAL)         
                         MOVE 'INVALID REQUEST, CHECK YOUR INPUT.'      
                              TO MSGO                                   
                         SET WS-MAP-DATAONLY TO TRUE                    
                         PERFORM 3030-SEND-MAP                          
                            THRU 3030-SEND-MAP-EXIT                     
                      ELSE                                              
                         PERFORM 3010-CHECK-INPUT                       
                            THRU 3010-CHECK-INPUT-EXIT                  
                         PERFORM 3020-XCTL                              
                            THRU 3020-XCTL-EXIT                         
                      END-IF                                            
                 WHEN OTHER                                             
                      MOVE 'INVALID KEY PRESSED!' TO MSGO               
                      SET WS-MAP-DATAONLY TO TRUE                       
                      PERFORM 3030-SEND-MAP                             
                         THRU 3030-SEND-MAP-EXIT                        
            END-EVALUATE                                                
            .                                                           
       3000-MAIN-PROCESS-EXIT.                                          
            EXIT.                                                       
      *                                                                 
       3010-CHECK-INPUT.                                                
            INITIALIZE CIMENU-REC                                       
            EVALUATE TRUE                                               
                WHEN (COMMUL NOT = 0)                                   
                     MOVE COMMUI TO CIMENU-TRANSID                      
                WHEN (MENUL  NOT = 0)                                   
                     MOVE MENUI  TO CIMENU-TRANSID                      
                WHEN (OPT1L  NOT = 0 AND OPT1I = 'S')                   
                     MOVE 'CI01' TO CIMENU-TRANSID                      
                WHEN (OPT2L  NOT = 0 AND OPT2I = 'S')                   
                     MOVE 'CI02' TO CIMENU-TRANSID                      
                WHEN (OPT3L  NOT = 0 AND OPT3I = 'S')                   
                     MOVE 'CI03' TO CIMENU-TRANSID                      
                WHEN (OPT4L  NOT = 0 AND OPT4I = 'S')                   
                     MOVE 'CI04' TO CIMENU-TRANSID                      
                WHEN (OPT5L  NOT = 0 AND OPT5I = 'S')                   
                     MOVE 'CI05' TO CIMENU-TRANSID                      
                WHEN OTHER                                              
                     MOVE 'INVALID INPUT' TO MSGO                       
                     SET WS-MAP-DATAONLY TO TRUE                        
                     PERFORM 3030-SEND-MAP THRU 3030-SEND-MAP-EXIT      
            END-EVALUATE                                                
            .                                                           
      *                                                                 
       3010-CHECK-INPUT-EXIT.                                           
            EXIT.                                                       
      *                                                                 
       3020-XCTL.                                                       
      *     INITIALIZE WS-COMMAREA                                      
      *     MOVE 'Y' TO WS-FIRST-SEND                                   
      *     EVALUATE CIMENU-TRANSID                                     
      *         WHEN 'CI01'                                             
      *              MOVE 0 TO WS-OPTION                                
      *         WHEN 'CI02'                                             
      *              MOVE 1 TO WS-OPTION                                
      *         WHEN 'CI03'                                             
      *              MOVE 2 TO WS-OPTION                                
      *         WHEN 'CI04'                                             
      *              MOVE 3 TO WS-OPTION                                
      *         WHEN 'CI05'                                             
      *              MOVE 4 TO WS-OPTION                                
      *     END-EVALUATE                                                
            EXEC CICS READ                                              
                 FILE('CIMENU')                                         
                 INTO(CIMENU-REC)                                       
                 RIDFLD(CIMENU-TRANSID)                                 
                 RESP(WS-RESP-CODE)                                     
            END-EXEC                                                    
            EVALUATE WS-RESP-CODE                                       
                WHEN DFHRESP(NORMAL)                                    
                     EXEC CICS                                          
                          XCTL PROGRAM(CIMENU-PGM)                      
                          COMMAREA(CIMENU-TRANSID)                      
                          RESP(WS-RESP-CODE)                            
                     END-EXEC                                           
                     IF WS-RESP-CODE NOT = DFHRESP(NORMAL)              
                        STRING 'PROGRAM ' DELIMITED BY SIZE             
                               CIMENU-PGM DELIMITED BY SPACE            
                               ' IS NOT AVAILABLE' DELIMITED BY SIZE    
                               INTO MSGO                                
                        SET WS-MAP-DATAONLY TO TRUE                     
                        PERFORM 3030-SEND-MAP THRU 3030-SEND-MAP-EXIT   
                     END-IF                                             
                WHEN DFHRESP(NOTFND)                                    
                     MOVE 'INVALID TRANSATION ID!' TO MSGO              
                     SET WS-MAP-DATAONLY TO TRUE                        
                     PERFORM 3030-SEND-MAP THRU 3030-SEND-MAP-EXIT      
                WHEN OTHER                                              
                     MOVE 'CIMENU FILE ERROR!' TO MSGO                  
                     SET WS-MAP-DATAONLY TO TRUE                        
                     PERFORM 3030-SEND-MAP THRU 3030-SEND-MAP-EXIT      
            END-EVALUATE                                                
            .                                                           
      *                                                                 
       3020-XCTL-EXIT.                                                  
            EXIT.                                                       
      *                                                                 
       3030-SEND-MAP.                                                   
            PERFORM 1010-ASK-TIME-DATE                                  
               THRU 1010-ASK-TIME-DATE-EXIT                             
            EVALUATE TRUE                                               
                WHEN WS-MAP-ERASE                                       
                     EXEC CICS SEND                                     
                          MAP('CICA00')                                 
                          MAPSET('CICA00')                              
                          FROM(CICA00O)                                 
                          ERASE                                         
                     END-EXEC                                           
                WHEN WS-MAP-DATAONLY                                    
                     EXEC CICS SEND                                     
                          MAP('CICA00')                                 
                          MAPSET('CICA00')                              
                          FROM(CICA00O)                                 
                          DATAONLY                                      
                     END-EXEC                                           
            END-EVALUATE                                                
            MOVE '1' TO WS-ENTER-FLAG                                   
            PERFORM 5020-RETURN-TRANS THRU 5020-RETURN-TRANS-EXIT       
            .                                                           
      *                                                                 
       3030-SEND-MAP-EXIT.                                              
            EXIT.                                                       
      *                                                                 
       4000-POST-PROCESSING.                                            
      *                                                                 
       4000-POST-PROCESSING-EXIT.                                       
            EXIT.                                                       
      *                                                                 
       5000-CLEAN-UP.                                                   
            PERFORM 5010-RETURN                                         
               THRU 5010-RETURN-EXIT                                    
            .                                                           
      *                                                                 
       5000-CLEAN-UP-EXIT.                                              
            EXIT.                                                       
      *                                                                 
       5010-RETURN.                                                     
            EXEC CICS RETURN END-EXEC                                   
            .                                                           
       5010-RETURN-EXIT.                                                
            EXIT.                                                       
      *                                                                 
       5020-RETURN-TRANS.                                               
            EXEC CICS RETURN TRANSID('CICA')                            
                      COMMAREA(WS-ENTER-FLAG)                           
            END-EXEC                                                    
            .                                                           
       5020-RETURN-TRANS-EXIT.                                          
            EXIT.