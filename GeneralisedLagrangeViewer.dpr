program GeneralisedLagrangeViewer;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  TypeUnit in 'TypeUnit.pas',
  ProjectUnit in 'ProjectUnit.pas',
  SettingUnit in 'SettingUnit.pas' {SettingForm},
  EnterDataUnit in 'EnterDataUnit.pas',
  ExitDataUnit in 'ExitDataUnit.pas',
  ReportUnit in 'ReportUnit.pas',
  LanguageUnit in 'LanguageUnit.pas',
  ShowTranslateFunctionUnit in 'ShowTranslateFunctionUnit.pas' {TranslateFunctionForm},
  DistinctionUnit in 'DistinctionUnit.pas',
  GenerateFunctionUnit in 'GenerateFunctionUnit.pas',
  HistoryUnit in 'HistoryUnit.pas',
  HelpUnit in 'HelpUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSettingForm, SettingForm);
  Application.CreateForm(TTranslateFunctionForm, TranslateFunctionForm);
  Application.Run;
end.
