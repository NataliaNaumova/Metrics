program GilbyMetric;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
