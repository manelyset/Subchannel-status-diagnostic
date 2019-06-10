 //SCH JOB                                                   
 //CLG EXEC ASMACL,PARM.L='AC=1'                             
 //L.SYSLMOD DD DISP=SHR,DSN=EMCPROJ.LOADLIB               
 //C.SYSIN DD *                                              
          YREGS                                              
 SCH     CSECT                                              
          STM   R14,R12,12(R13)                                
          BALR  R12,R0                                        
          USING *,R12                                        
 STRTPROC EQU * 
 * SAVING REGISTER VALUES TO THE SAVEAREA                                             
          ST R13,SAVEAREA+4                                  
          LR R2,R13                                          
          LA R13,SAVEAREA                                    
          ST R13,8(2)
 * CONVERTING THE PARM VALUE TO HEXADECIMAL FORMAT                                        
          L    R2,0(R1)                                        
          TR   2(4,R2),PTABLE                                  
          L    R3,2(R2)                                         
          PACK PACKED(4),2(4,R2)                             
          L    R3,PACKED                                        
          SRL  R3,4                                           
          ST   R3,PACKED                                       
          MODESET MODE=SUP                                   
          L    R2,PACKED 
 * LOAD THE BIGGEST SUBCHANNEL NUMBER TO R1
 * NECESSARY FOR CORRECT EXECUTION OF STSCH                                      
          L R1,SCHN                                          
 LOOP     DS  0H 
          C   R1,=X'0000FFFF'
          BZ  'NF'		  
          STSCH SCHIB   
          LH  R3,SCHIB+6                          
          CR  R2,R3                               
          BZ  ENDLOOP                             
          AHI R1,-1                              
          BP  LOOP
 * DEVICE WAS NOT FOUND		  
 NF		  DS 0H
          WTO 'DEVICE NOT FOUND!'
		  B   ERR
 ENDLOOP  DS  0H 
 * OUTPUT                                 
          ST  R1,SCHNUM
                           
          WTO 'INTERRUPTION PARAMETER:'          
          UNPK UNPCKD(16),SCHIB(8)               
          TR   UNPCKD+1(16),UPTABLE               
          MVC  INTPV+2(8),UNPCKD+1                
          WTO  TEXT=INTPV 
                        
          XC UNPCKD,UNPCKD 
                      
          WTO 'DEVICE NUMBER'                    
          UNPK UNPCKD(6),SCHIB+6(3)              
          TR   UNPCKD+1(4),UPTABLE                
          MVC  DEVNV+2(4),UNPCKD+12               
          WTO  TEXT=DEVNV  
                       
          XC UNPCKD,UNPCKD  
                     
          WTO 'SUBCHANNEL NUMBER:'               
          UNPK UNPCKD(10),SCHNUM(5)              
          TR   UNPCKD+1(8),UPTABLE                
          MVC  SCHNV+2(8),UNPCKD+1                
          WTO  TEXT=SCHNV 
		  
		  WTO 'STATUS'
		  XR   R2,R2
		  LH   R2,SCHIB+4
		  NILL R2,X'80'
          BZ DIS
		  
 EN:      WTO 'ENABLED'
          B CONT
 DIS:     WTO 'DISABLED'
 CONT:	  DS  0H 	 
                       
          XC UNPCKD,UNPCKD 
                      
          WTO 'LPM:'               
          UNPK UNPCKD(10),SCHIB+8(5)           
          TR   UNPCKD+1(4),UPTABLE              
          MVC  LPMV+2(8),UNPCKD+1               
          WTO  TEXT=LPMV 
		  
		  XC UNPCKD,UNPCKD 
                      
          WTO 'PNOM:'               
          UNPK UNPCKD(10),SCHIB+9(5)           
          TR   UNPCKD+1(4),UPTABLE              
          MVC  PNOMV+2(8),UNPCKD+1               
          WTO  TEXT=PNOMV 
		  
		  XC UNPCKD,UNPCKD 
                      
          WTO 'LPUM:'               
          UNPK UNPCKD(10),SCHIB+10(5)           
          TR   UNPCKD+1(4),UPTABLE              
          MVC  LPUMV+2(8),UNPCKD+1               
          WTO  TEXT=LPUMV 
		  
		  XC UNPCKD,UNPCKD 
                      
          WTO 'PIM:'               
          UNPK UNPCKD(10),SCHIB+11(5)           
          TR   UNPCKD+1(4),UPTABLE              
          MVC  PIMV+2(8),UNPCKD+1               
          WTO  TEXT=PIMV
		  
		  XC UNPCKD,UNPCKD 
                      
          WTO 'POM:'               
          UNPK UNPCKD(10),SCHIB+14(5)           
          TR   UNPCKD+1(4),UPTABLE              
          MVC  POMV+2(8),UNPCKD+1               
          WTO  TEXT=POMV 
		  
		  XC UNPCKD,UNPCKD 
                      
          WTO 'PAM:'               
          UNPK UNPCKD(10),SCHIB+15(5)           
          TR   UNPCKD+1(4),UPTABLE              
          MVC  PAMV+2(8),UNPCKD+1               
          WTO  TEXT=PAMV 		  

 * LOADING LPM TO R15                       
          LH R1,SCHIB+8                   
          ST R1,16(R13)
          B FINISH
 * RETURNING FFFFFFFF IN CASE OF ERROR		  
 ERR	  L R1,=X'FFFFFFFF'                   
          ST R1,16(R13)	  
 * RESTORING REGISTER VALUES FROM THE SAVEAREA                       
 FINISH   L  R13,SAVEAREA+4                    
          LM R14,R12,12(R13)                   
          BR R14 
 * STORAGES AND CONSTANTS DEFINITION                              
 SAVEAREA DS 18F                               
 SCHN     DC X'0001FFFF'                       
 SCHNUM   DS F                                 
          DS 0D                                
 SCHIB    DS 12F                               
 PACKED   DC XL2'0'                            
 UNPCKD   DC CL16'0'                           
 PTABLE   DC XL255'0'                          
          ORG PTABLE+C'0'                      
          DC  X'00'                            
          ORG PTABLE+C'1'                      
          DC  X'01'                            
          ORG PTABLE+C'2'                      
          DC  X'02'                            
          ORG PTABLE+C'3'                      
          DC  X'03'                            
          ORG PTABLE+C'4'                    
          DC  X'04'                          
          ORG PTABLE+C'5'                    
          DC  X'05'                          
          ORG PTABLE+C'6'                    
          DC  X'06'                          
          ORG PTABLE+C'7'                    
          DC  X'07'                          
          ORG PTABLE+C'8'                    
          DC  X'08'                          
          ORG PTABLE+C'9'                    
          DC  X'09'                          
          ORG PTABLE+C'A'                    
          DC  X'0A'                          
          ORG PTABLE+C'B'                    
          DC  X'0B'                          
          ORG PTABLE+C'C'                    
          DC  X'0C'                          
          ORG PTABLE+C'D'                    
          DC  X'0D'                          
          ORG PTABLE+C'E'                    
          DC  X'0E'                          
          ORG PTABLE+C'F'                    
          DC  X'0F'                          
 UPTABLE  DC XL255'0'                        
         ORG UPTABLE+X'F0'                  
         DC  C'0'                           
         ORG UPTABLE+X'F1'                      
         DC  C'1'                               
         ORG UPTABLE+X'F2'                      
         DC  C'2'                               
         ORG UPTABLE+X'F3'                      
         DC  C'3'                               
         ORG UPTABLE+X'F4'                      
         DC  C'4'                               
         ORG UPTABLE+X'F5'                      
         DC  C'5'                               
         ORG UPTABLE+X'F6'                      
         DC  C'6'                               
         ORG UPTABLE+X'F7'                      
         DC  C'7'                               
         ORG UPTABLE+X'F8'                      
         DC  C'8'                               
         ORG UPTABLE+X'F9'                      
         DC  C'9'                               
         ORG UPTABLE+X'FA'                      
         DC  C'A'                               
         ORG UPTABLE+X'FB'                      
         DC  C'B'                               
         ORG UPTABLE+X'FC'                      
         DC  C'C'                               
         ORG UPTABLE+X'FD'                      
         DC  C'D'                               
         ORG UPTABLE+X'FE'  
          DC  C'D'                            
          ORG UPTABLE+X'FE'                   
          DC  C'E'                            
          ORG UPTABLE+X'FF'                   
          DC  C'F'                            
 INTPV    DC XL2'8'                           
          DC CL8'0'                           
 DEVNV    DC XL2'4'                           
          DC CL4'0'                           
 SCHNV    DC XL2'8'                           
          DC CL8'0'                           
 LPMV     DC XL2'4'                           
          DC CL4'0' 
 PNOMV    DC XL2'4'                           
          DC CL4'0'
 LPUMV    DC XL2'4'                           
          DC CL4'0'
 PIMV     DC XL2'4'                           
          DC CL4'0'
 POMV     DC XL2'4'                           
          DC CL4'0'
 PAMV     DC XL2'4'                           
          DC CL4'0'	  
		  
          END
 * RUNNING WITH DEVICE #0A81                                
 //RUN    EXEC PGM=SCH,PARM='0A81'            
 //STEPLIB DD DISP=SHR,DSN=EMCPROJ.LOADLIB                                                           