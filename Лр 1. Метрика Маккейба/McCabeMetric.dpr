program McCabeMetric;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
