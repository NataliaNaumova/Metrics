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
    StringGrid: TStringGrid;
    LabelZNumber: TLabel;
    procedure ButtonAnalyzeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
DynamicMatrix = array of array of Integer;
DynamicArray = array of String;
BooleanArray = array of Boolean;

var
  MainFrm: TMainFrm;
  CodeFile: Text;
  AdjacencyMatrix: DynamicMatrix;
  ArrayofLines: DynamicArray;
  SeenCode:BooleanArray;

implementation



{$R *.dfm}

procedure TMainFrm.ButtonAnalyzeClick(Sender: TObject);
  const
    OpeningBraceRegExp = '.*{';
    ConnectedComponentsCount = 1;

  var
  BlocksCount,i,CurrentNode,CiclomaticNumberZ,NewBlockPosition:integer;
  RegEx:TRegEx;
  MainBlock,Statement: String;


  procedure DeleteComments;
    var
    i,j:integer;
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


  procedure AddNode(var AdjacencyMatrix: DynamicMatrix);
    var i,j:integer;
    begin
      SetLength(AdjacencyMatrix,(length(AdjacencyMatrix)+1));
      For i:=0 to (length(AdjacencyMatrix)-1) do
      begin
        SetLength(AdjacencyMatrix[i],length(AdjacencyMatrix));
      end;
    end;

    procedure MakeNodeFromCurrent;
    begin
      AddNode(AdjacencyMatrix);
      AdjacencyMatrix[CurrentNode,high(AdjacencyMatrix[CurrentNode])]:=1;
    end;


  procedure FindBegin;
    var
    i,BracketsCount:integer;

  begin
    i:=0;
    MainBlock:='';
    NewBlockPosition:=0;
    BracketsCount:=-1;
    while (i<=(length(ArrayofLines)-1)) and (BracketsCount<>0) do
    begin
      if RegEx.IsMatch(ArrayofLines[i],'^\w+\s+main(.+)') then
      begin
        inc(i);
        BracketsCount:=1;
        if RegEx.IsMatch(ArrayofLines[i],'{') then
          inc(i);
        while (i<=(length(ArrayofLines)-1)) do
        begin
          if RegEx.IsMatch(ArrayofLines[i],OpeningBraceRegExp) then
            inc(BracketsCount);
          if RegEx.IsMatch(ArrayofLines[i],'.*}') then
            dec(BracketsCount);
          if (BracketsCount<>0) then
          begin
            MainBlock:=MainBlock+ArrayofLines[i];
            inc(i);
          end;
        end;

      end;
      inc(i);
    end;

  end;

  procedure AnalyzeBlock(Block : String);
    var
    i,j:integer;
    CiclomaticNumberZ:integer;
    Statement: String;
    StatementRead:Boolean;

    procedure PickOutSubBlock(var Block:String; var NewBlock:String;  var NextStatement: String; i:integer);
    var
      BracketsCount,j,PositioninStatement:integer;
    begin
        BracketsCount:=1;
        NewBlock:='';

        PositioninStatement:=1;
        while Statement[PositioninStatement-1]<>'{' do
          inc(PositioninStatement);
        for j := PositioninStatement to Length(Statement) do
        begin
          SetLength(NewBlock,length(NewBlock)+1);
          NewBlock[length(NewBlock)]:=Statement[j];
          Statement[j]:=#0;
        end;

        j:=i;
        while (BracketsCount<>0) and (j<=length(Block)) do
        begin
          if Block[j]='{' then
          begin
            inc(BracketsCount);
            inc(j);
          end;
          if Block[j]='}' then
          begin
            dec(BracketsCount);
            inc(j);
          end;
          if (BracketsCount<>0) then
          begin
            SetLength(NewBlock,length(NewBlock)+1);
            NewBlock[length(NewBlock)]:=Block[j];
            Block[j]:=#0;
            inc(j);
          end;
        end;
        NextStatement:='';
        if j<=length(Block) then
        begin
          repeat
            NextStatement:=NextStatement + Block[j];
            inc(j);
          until (Block[j-1]=';') or (j>length(Block));
        end;
    end;


    procedure FindIf;
    const
      IfRegExp = 'if\s*\((.+?)\)\s*';
      ElseRegExp = 'else\s*?';

    var
      ProbablyElseStatement, BufStatement, BlockIf,BlockElse: String;
      j,ConditionNode,ExitNode:integer;
      HasBlockIf: Boolean;

    begin
      if RegEx.IsMatch(Statement,IfRegExp) then
      begin
        MakeNodeFromCurrent;
        CurrentNode:=High(AdjacencyMatrix);
        ConditionNode:=CurrentNode;
        MakeNodeFromCurrent;
        CurrentNode:=High(AdjacencyMatrix);
        if RegEx.IsMatch(Statement,OpeningBraceRegExp) then
        begin
          HasBlockIf:=True;
          ProbablyElseStatement:='';
          j:=i;
          PickOutSubBlock(Block,BlockIf,ProbablyElseStatement,i);
        end
        else
        begin
          ProbablyElseStatement:='';
          j:=i;
          ProbablyElseStatement:='';
          if j<=length(Block) then
          begin
            repeat
              ProbablyElseStatement:=ProbablyElseStatement + Block[j];
              inc(j);
            until (Block[j-1]=';') or (j>length(Block));
          end;
        end;
        if HasBlockIf then
          AnalyzeBlock(BlockIf);
        HasBlockIf:=False;

        if RegEx.IsMatch(ProbablyElseStatement,'ElseRegExp') then
        begin
          MakeNodeFromCurrent;
          ExitNode:=High(AdjacencyMatrix);

          CurrentNode:=ConditionNode;
          MakeNodeFromCurrent;
          CurrentNode:=High(AdjacencyMatrix);

          if RegEx.IsMatch(ProbablyElseStatement,OpeningBraceRegExp) then
          begin
            PickOutSubBlock(Block,BlockElse,BufStatement,j);
            AnalyzeBlock(BlockElse);
          end;

          AdjacencyMatrix[CurrentNode,ExitNode]:=1;
        end
        else
        begin
          MakeNodeFromCurrent;
          CurrentNode:=High(AdjacencyMatrix);
          AdjacencyMatrix[ConditionNode,CurrentNode]:=1;
        end;
      end;

    end;



    procedure FindForWhile;
    const
      ForRegExp = 'for\s*\(';
      WhileRegExp = 'while\s*\((.+?)\)\s*';
      CommonForSemicolonAmount = 3;

    var
      BufStatement,BlockFor: string;
      SemicolonCount,ConditionNode:integer;

    begin
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

      if RegEx.IsMatch(Statement,WhileRegExp) or RegEx.IsMatch(Statement,ForRegExp) then
      begin
        MakeNodeFromCurrent;
        CurrentNode:=High(AdjacencyMatrix);
        ConditionNode:=CurrentNode;

        MakeNodeFromCurrent;
        CurrentNode:=High(AdjacencyMatrix);

        if RegEx.IsMatch(Statement,OpeningBraceRegExp) then
        begin
          BufStatement:='';
          j:=i;
          PickOutSubBlock(Block,BlockFor,BufStatement,i);
          AnalyzeBlock(BlockFor);
        end;

        AdjacencyMatrix[CurrentNode,ConditionNode]:=1;
        CurrentNode:=ConditionNode;
        MakeNodeFromCurrent;
        CurrentNode:=High(AdjacencyMatrix);
      end;
    end;

    procedure FindSwitch;
    const
      SwitchRegExp = 'switch\s*\(.*\)\s*\{';
      CaseRegExp = 'case\s*.*:.*\sbreak\s*;';
      DefaultCaseRegExp = 'default\s*:';

    var
      BufStatement,BlockSwitch,BlockCase: string;
      ExitNodewasCreated,DefaultCaseExists:Boolean;
      j, ExitNode, ConditionNode:integer;

    begin
      ExitNodewasCreated:=False;
      if RegEx.IsMatch(Statement,SwitchRegExp) then
      begin
        MakeNodeFromCurrent;
        ConditionNode:=High(AdjacencyMatrix);

        PickOutSubBlock(Block,BlockSwitch,BufStatement,i);

        j:=1;
        repeat
          BlockCase:='';
          repeat
            SetLength(BlockCase,length(BlockCase)+1);
            BlockCase[length(BlockCase)]:=BlockSwitch[j];
            BlockSwitch[j]:=#0;
            inc(j)
          until (RegEx.IsMatch(BlockCase,CaseRegExp)) or (j>length(BlockSwitch));

          CurrentNode:=ConditionNode;
          MakeNodeFromCurrent;
          CurrentNode:=High(AdjacencyMatrix);

          if (RegEx.IsMatch(BlockCase,CaseRegExp)) then
            AnalyzeBlock(BlockCase);

          if (RegEx.IsMatch(BlockCase,DefaultCaseRegExp)) then
          begin
            DefaultCaseExists:=True;
            AnalyzeBlock(BlockCase);
          end;

          if not ExitNodewasCreated then
          begin
            MakeNodeFromCurrent;
            ExitNode:=High(AdjacencyMatrix);
            ExitNodewasCreated:=True;
          end
          else
            AdjacencyMatrix[CurrentNode,ExitNode]:=1;
        until j>length(BlockSwitch);
        CurrentNode:=ExitNode;
      end;
    end;

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


        FindIf;

        FindForWhile;

        FindSwitch;

      until i>length(Block);


  end;


  function ArcCount(const Matrix:DynamicMatrix): integer;
  var i,j:integer;
  begin
    Result:=0;
    for i := Low(Matrix) to High(Matrix) do
      for j := Low(Matrix[i]) to High(Matrix[i]) do
        if Matrix[i,j]=1 then
          inc(Result);
  end;


  procedure ShowMatrix(const Matrix:DynamicMatrix);
  var i,j:integer;
  begin
    with StringGrid do
    begin
      for i:=0 to ColCount-1 do
        Cols[i].Clear;

      RowCount:=Length(Matrix)+1;
      ColCount:=Length(Matrix)+1;
      for i := 0 to RowCount do
        Cells[0,i+1]:=InttoStr(i);
      for i := 0 to ColCount do
        Cells[i+1,0]:=InttoStr(i);
      for i:=0 to High(Matrix) do
        for j:=0 to High(Matrix) do
        begin
          Cells[j+1,i+1]:=InttoStr(Matrix[i,j]);
        end;
      Visible:=True;
    end;
  end;


begin
  if EditEnterPace.text='' then
    ShowMessage('Укажите имя файла')
  else
  begin
    SetLength(ArrayOfLines,0);
    SetLength(AdjacencyMatrix,0);
    MainBlock:='';
    AssignFile(CodeFile,EditEnterPace.Text);
    Reset(CodeFile);
    while (not (Eof(Codefile))) do
    begin
      SetLength(ArrayofLines,length(ArrayofLines)+1);
      Readln(CodeFile,ArrayofLines[length(ArrayofLines)-1]);
    end;
    CloseFile(CodeFile);
    DeleteComments;
    RegEx.Create('');
    FindBegin;
    CurrentNode:=0;
    AddNode(AdjacencyMatrix);
    AnalyzeBlock(MainBlock);

    BlocksCount:=length(AdjacencyMatrix);
    ShowMatrix(AdjacencyMatrix);
    CiclomaticNumberZ:=ArcCount(AdjacencyMatrix)-BlocksCount+2*ConnectedComponentsCount;
    LabelZNumber.Caption:='Цикломатическое число Мак-Кейба = '+inttostr(CiclomaticNumberZ);
    LabelZNumber.Visible:=True;
  end;
end;

end.
