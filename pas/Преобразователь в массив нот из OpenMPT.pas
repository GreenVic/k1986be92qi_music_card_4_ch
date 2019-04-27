Program Pr;
var input: text;                                                                //������ ������. 
    BufNOT: byte;                                                               //����� ����.
    MESNOT: array [0..3, 0..1000, 0..1] of integer;                             //������ �� 10000 ��� � ������ ������.
    BIGSTRING: string;                                                          //����� ������ �� 4 ������.
    Chene_ST:  string;                                                          //������ ��� ������ ������.
    LoopNOTE_Chenel: array [0..3] of integer;                                   //����� ���� � ������ ������.
    LoopDELAY_Chenel: array [0..3] of integer;                                  //�������� � ������ ������.
    LoopChenel: integer;                                                        //������� �������.
    I: integer; 
    FLAG_ONE_NOTE: array [0..3] of byte;                                        //���� ����������, ��� ���� �� ���� ���� �� � ������ ����. ����� "�����" �� 1-� ����.
//������� ��������� ������ - ������ ����� ����. 
function PR_String_to_NambeNote (DataST: string): integer;
var Buffer: integer;
    MNOG:   integer;
    errorS: integer; 
Begin
  case DataST[2] of                                                             //�� ����� � ������� # ����������� ����� ���� � �������� ����� �����. 
  'C': if (DataST[3]='-') then Buffer:=0 else Buffer:=1;
  'D': if (DataST[3]='-') then Buffer:=2 else Buffer:=3;
  'E': Buffer:=4;
  'F': if (DataST[3]='-') then Buffer:=5 else Buffer:=6;
  'G': if (DataST[3]='-') then Buffer:=7 else Buffer:=8;
  'A': if (DataST[3]='-') then Buffer:=9 else Buffer:=10;
  'B': Buffer:=11;
  '=': Buffer:=132; End;
  if (Buffer<>132) then
  Begin
    val(DataST[4], MNOG, errorS);                                               //�������� ����� ������.
    Buffer:=Buffer+12*MNOG;                                                     //�������� ����� ���� �� ����� ������.
  End;
  PR_String_to_NambeNote:=Buffer;                                               //������ �����/�����
End;

Begin
  assign(input, 'INPUT.txt'); reset(input);                                     //���������� ���� ��� ������.
  while not eof(input) do                                                       //������ ��� ������.
  Begin 
    readln(input, BIGSTRING);                                                   //����� ������ ��� 4-� �������. 
    if (BIGSTRING[1] = '|') then                                                //���� ��� ������ ���� ������, ��.
    Begin
      for LoopChenel:=0 to 3 do                                                 //�������� ��� 4 ������.
      Begin
        Chene_ST:=copy(BIGSTRING, 1+12*LoopChenel, 4);                          //�������� �� ����� ������ ������ �����.    
        if (Chene_ST[2]<>'.') then                                              //���� ����� ���� ����, ��.
        Begin          
          if (FLAG_ONE_NOTE[LoopChenel]=0) then                                 //���� �� ���� ���� �� ���� �� �����, �� ������� �� ��� �����.
          Begin
            if (LoopDELAY_Chenel[LoopChenel]<>0) then
            Begin
              MESNOT[LoopChenel][0][0]:=132;                                    //����������� ��������� � "0".
              MESNOT[LoopChenel][0][1]:=LoopDELAY_Chenel[LoopChenel];           //��������� ������������ �����.
              LoopNOTE_Chenel[LoopChenel]:=LoopNOTE_Chenel[LoopChenel]+1;       //����������� ��������� �� �������� ����.
            End;
            FLAG_ONE_NOTE[LoopChenel]:=1;
          End;
          MESNOT[LoopChenel][LoopNOTE_Chenel[LoopChenel]][0]:=PR_String_to_NambeNote(Chene_ST);   //�������� ����� ����. 
          if (LoopNOTE_Chenel[LoopChenel]<>0) then
           MESNOT[LoopChenel][LoopNOTE_Chenel[LoopChenel]-1][1]:=LoopDELAY_Chenel[LoopChenel];    //��������� ������������ ���������� (���� ��� ����).
          LoopNOTE_Chenel[LoopChenel]:=LoopNOTE_Chenel[LoopChenel]+1;                             //����������� ��������� �� �������� ����.
          LoopDELAY_Chenel[LoopChenel]:=1;                                                        //�� ��������� ������ ���� 1/128.     
        End
        else LoopDELAY_Chenel[LoopChenel]:=LoopDELAY_Chenel[LoopChenel]+1;      //���� ������ ����� - ������ ����.
      End;
    End;
  End;
  
  MESNOT[0][LoopNOTE_Chenel[0]-1][1]:=LoopDELAY_Chenel[0];                      //����������� ��������� ���� �� ��������.  
  MESNOT[1][LoopNOTE_Chenel[1]-1][1]:=LoopDELAY_Chenel[1];                      //����������� ��������� ���� �� ��������.  
  MESNOT[2][LoopNOTE_Chenel[2]-1][1]:=LoopDELAY_Chenel[2];                      //����������� ��������� ���� �� ��������.  
  MESNOT[3][LoopNOTE_Chenel[3]-1][1]:=LoopDELAY_Chenel[3];                      //����������� ��������� ���� �� ��������.  
  
  for LoopChenel:=0 to 3 do
  Begin
    write('uint16_t MusicNote', LoopChenel, '[', LoopNOTE_Chenel[LoopChenel], '][2] = {');
    for I:=0 to LoopNOTE_Chenel[LoopChenel]-1 do 
    Begin
      write (MESNOT[LoopChenel][I][0],  ',', MESNOT[LoopChenel][I][1]);  
      if (I<>LoopNOTE_Chenel[LoopChenel]-1) then write(', ');
    End;
    writeln('};');
  End;
End.