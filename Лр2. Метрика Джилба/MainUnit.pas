unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, RegularExpressions, RegularExpressionsCore, RegularExpressionsConsts;

type
  TMainFrm = class(TForm)
    LabelEnterPace: TLabel;
    EditEnterPace: TEdit;
    ButtonAnalyze: TButton;
    lblIfThenElseCount: TLabel;
    lblCommonOperatorCount: TLabel;
    lblRelativeProgramComplexity: TLabel;
    procedure ButtonAnalyzeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
DynamicArray = array of String;

var
  MainFrm: TMainFrm;
  CodeFile: Text;
  ArrayofLines: DynamicArray;

implementation


{$R *.dfm}

procedure TMainFrm.ButtonAnalyzeClick(Sender: TObject);

  var
  OperatorsCount,i,IfThenElseCount,NewBlockPosition: integer;
  RelativeProgramComplexity: real;
  RegEx: TRegEx;
  Statement,Block: String;


  procedure DeleteComments;
    var
    i,j: integer;
    Statement: String;
    MultilineCommentisOpen: boolean;

    procedure DeleteSingleLineComments(var Line:String; var MultilineCommentisOpen: boolean);
      var
      i:integer;
      StringisOpen,CommentDeleted:boolean;

      begin
        StringisOpen:=False;
        CommentDeleted:=False;
        i:=1;
        while (i<=(length(Line)-1)) and not(CommentDeleted) do
        begin
          if Line[i]='"' then
            if not(StringIsOpen) then
              StringisOpen:=True else
              StringisOpen:=False;
          if (Line[i]='/') and (Line[i+1]='*') and (not(StringisOpen)) then
              MultilineCommentisOpen:=True;
          if (Line[i]='*') and (Line[i+1]='/') and (not(StringisOpen)) then
              MultilineCommentisOpen:=False;
          if ((Line[i]='/') and (Line[i+1]='/')) and ((not(StringisOpen)) and (not(MultilineCommentisOpen))) then
          begin
            Delete(Line, i,length(Line)-i+1);
            CommentDeleted:=True;
          end;
          inc(i);
        end;
      end;

    procedure DeleteStrings(var Line:String);
      var
      i:integer;
      StringisOpen:boolean;
      BufLine: String;

      begin
        StringisOpen:=False;
        BufLine:='';
        for i:=1 to length(Line) do
        begin
          if Line[i]='"' then
            if not(StringIsOpen) then
              StringisOpen:=True
            else
              StringisOpen:=False;
          if (not(StringisOpen)) and (Line[i]<>'"') then
            BufLine:=BufLine+Line[i];
        end;
        Line:=BufLine;
      end;


    procedure DeleteMultiLineComments(var Line:String; var MultilineCommentisOpen: boolean);
      var
      i:integer;
      StringisOpen:boolean;
      BufLine: String;

      begin
        StringisOpen:=False;
        BufLine:='';
        for i:=1 to (length(Line)-1) do
        begin
          if Line[i]='"' then
            if not(StringIsOpen) then
              StringisOpen:=True else
              StringisOpen:=False;
          if (Line[i]='/') and (Line[i+1]='*') and (not(StringisOpen)) then
            MultilineCommentisOpen:=True;
          if (Line[i]='*') and (Line[i+1]='/') and (not(StringisOpen)) then
            begin
            MultilineCommentisOpen:=False;
            Delete(Line,i,2);
            Insert(' ',Line,i);
            end;
          if not(MultilineCommentisOpen) then
          begin
            BufLine:=BufLine+Line[i];
            if i=(length(Line)-1) then
              BufLine:=BufLine+Line[i+1];
          end;
        end;
        Line:=BufLine;
      end;


    begin
      MultilineCommentisOpen:=False;
      for i:=0 to (length(ArrayofLines)-1) do
      begin
        DeleteSingleLineComments(ArrayofLines[i],MultiLineCommentisOpen);
      end;

      MultilineCommentisOpen:=False;
      for i:=0 to (length(ArrayofLines)-1) do
      begin
        DeleteMultiLineComments(ArrayofLines[i],MultiLineCommentisOpen);
      end;

      for i:=0 to (length(ArrayofLines)-1) do
      begin
        DeleteStrings(ArrayofLines[i]);
      end;

    end;


  function BlockFrom(ArrayofLines: DynamicArray): String;
  var
    i: integer;

  begin
    Result:='';
    for i := Low(ArrayofLines) to High(ArrayofLines) do
      Result:=Result+ArrayofLines[i];
  end;

  procedure AnalyzeBlock(Block : String);
    const
      IfRegExp = 'if\s*\((.+?)\)\s*';
      ForRegExp = 'for\s*\(';
      CommonForSemicolonAmount = 3;

    var
      i,j,SemicolonCount:integer;
      Statement: String;
      StatementRead: Boolean;

  begin
    i:=1;
    if Block<>'' then
      repeat
        Statement:='';
        StatementRead:=False;
        j:=1;
        repeat
          SetLength(Statement,length(Statement)+1);
          Statement[j]:=Block[i];
          if Block[i]=';' then
            StatementRead:=True;
          Block[i]:=#0;
          inc(i);
          inc(j);
        until StatementRead or (i>length(Block));

        if RegEx.IsMatch(Statement,ForRegExp) then
        begin
          SemicolonCount:=CommonForSemicolonAmount-1;
          repeat
            Setlength(Statement,length(Statement));
            Statement:=Statement+Block[i];
            if Block[i]=';' then
              dec(SemicolonCount);
            Block[i]:=#0;
            inc(i);
          until (SemicolonCount=0) or (i>length(Block));
        end;

        IfThenElseCount:=IfThenElseCount+RegEx.Matches(Statement,IfRegExp).Count;
        inc(OperatorsCount);

      until i>length(Block);


  end;


begin
  if EditEnterPace.text='' then
    ShowMessage('������� ��� �����')
  else
  begin
    SetLength(ArrayOfLines,0);
    AssignFile(CodeFile,EditEnterPace.Text);
    Reset(CodeFile);
    while (not (Eof(Codefile))) do
    begin
      SetLength(ArrayofLines,length(ArrayofLines)+1);
      Readln(CodeFile,ArrayofLines[length(ArrayofLines)-1]);
    end;
    CloseFile(CodeFile);
    DeleteComments;
    Block:=BlockFrom(ArrayofLines);
    RegEx.Create('');

    OperatorsCount:=0;
    IfThenElseCount:=0;
    AnalyzeBlock(Block);

    RelativeProgramComplexity:=IfThenElseCount/OperatorsCount;

    lblIfThenElseCount.Caption:='���������� ����������� If-Then-Else = '+inttostr(IfThenElseCount);
    lblCommonOperatorCount.Caption:='����� ���������� ���������� = '+inttostr(OperatorsCount);
    lblRelativeProgramComplexity.Caption:='������������� ��������� ��������� = '+floattostr(RelativeProgramComplexity);
    lblIfThenElseCount.Visible:=True;
    lblCommonOperatorCount.Visible:=True;
    lblRelativeProgramComplexity.Visible:=True;
  end;
end;

end.

