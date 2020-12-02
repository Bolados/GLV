﻿unit HelpUnit;

interface
// используемые библиотеки
  uses SysUtils,Windows,Forms,Controls,dialogs,Menus,Messages;
  //объявление константы
  const HelpFileName:TFileName='C:\GLViewer Help.chm';

  //объявление публичных методы

  //обработчик установка значении контекта каждого компонента программной системы
  Procedure setHelpContext;
  //обрабочик отображения справочной системы
  procedure WMHelp(var aMessage: TWMHelp;Menu,PopupMenu: TMenu);

implementation
// используемые модулы
  uses TypeUnit,MainUnit,SettingUnit,ShowTranslateFunctionUnit,ProjectUnit;

// контекиное отображение систем помоши по пунктам меню  главного окна
function GetMenuHelpContext(Menu: TMenu; aMessage: TWMHelp): Integer;
begin
  Result := 0;
  //если сушествует компоненты в меню
  if (Menu <> nil) then
  begin
  // получение контекта
    Result := Menu.GetHelpContext(aMessage.HelpInfo.iCtrlId, true);
    if (Result = 0) then   // если полученный контект равен 0
    // наидем контект родитель
      Result := Menu.GetHelpContext(aMessage.HelpInfo.hItemHandle, false);
  end;
end;

//обрабочик отображения справочной системы
procedure WMHelp(var aMessage: TWMHelp;Menu,PopupMenu: TMenu);
var
  Control: TWinControl;
  ContextId: integer;
  hlp: HWND;
  h:string;
begin
  if (aMessage.HelpInfo.iContextType = HELPINFO_WINDOW) then
  begin
    Control := FindControl(aMessage.HelpInfo.hItemHandle);
    // Ищем активный компонент
    while ((Control <> nil) and (Control.HelpContext = 0)) do
      Control := Control.Parent;
    if (Control = nil) then
      Exit;
    ContextId := Control.HelpContext; // Смотрим у него HelpContext
  end
  else
  begin       // если требует отображать систему помоши по пунктам меню

    ContextId := GetMenuHelpContext(Menu, aMessage); // ишем контект
    if (ContextId = 0) then
      ContextId := GetMenuHelpContext(PopupMenu, aMessage);
  end;
  h:=HelpFileName ;
  //отображение систем помоши
  hlp := HtmlHelp(Application.Handle, PChar(h), HH_HELP_CONTEXT,
    ContextId);
  // если не найден систему помоши то сообщает пользователя об ошибке
  if (hlp = 0) then
    case TypeUnit.SChooseLanguage of
      1: ProjectUnit.Info('Error. Look for the CHM file in the correct folder',mtWarning);
      0: ProjectUnit.Info('Помощь не найдена! Проверяете если файл с расширением ".chm" в папке C:\',mtWarning);
    end;
end;

//обработчик установка значении контекта каждого компонента программной системы
Procedure setHelpContext;
var i:integer;
begin
  // используем контанты файла mapFile.inc объявлены в модуле TypeUnit
  MainUnit.MainForm.HelpContext:=TypeUnit.IDH_TOPIC_GLAVNOE_OKNO;
  MainUnit.MainForm.Project.HelpContext:=IDH_CONTROL_PANEL_INSTRUMENTOV_PRILOZHENIJ_PROEKT;
  MainUnit.MainForm.NewProject.HelpContext:=TypeUnit.IDH_CONTROL_PROEKT_NOVYJ_PROEKT_____________________________________CTRL_N;
  MainUnit.MainForm.LoadProject.HelpContext:=TypeUnit.IDH_CONTROL_PROEKT_ZAGRUZIT_PROEKT_________________________________CTRL_O;
  MainUnit.MainForm.SaveProject.HelpContext:=TypeUnit.IDH_CONTROL_PROEKT_SOKHRANIT_PROEKT________________________________CTRL_S;
  MainUnit.MainForm.SaveProjectAs.HelpContext:=TypeUnit.IDH_CONTROL_PROEKT_SOKHRANIT_PROEKT_KAK_______________CTRL_SHIFT_S;
  MainUnit.MainForm.ExitProject.HelpContext:=TypeUnit.IDH_CONTROL_PROEKT_VYKHOD_IZ_PROGRAMMY____________________________ALT_F4;
  MainUnit.MainForm.EnterData.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_INSTRUMENTOV_PRILOZHENIJ_PODKLYUCHIT_ILI_OTKLYUCHIT_VVOD_DANNYKH;
  MainUnit.MainForm.ExitData.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_INSTRUMENTOV_PRILOZHENIJ_PODKLYUCHIT_ILI_OTKLYUCHIT_VYVOD_DANNYKH;
  MainUnit.MainForm.Setting.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_INSTRUMENTOV_PRILOZHENIJ_NASTROJKA;
  MainUnit.MainForm.VerificationConstruction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_INSTRUMENTOV_PRILOZHENIJ_PODKLYUCHIT_ILI_OTKLYUCHIT_PROVERKU_POSTROENIYA ;
  MainUnit.MainForm.ZoomAndScale.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_INSTRUMENTOV_PRILOZHENIJ_PODKLYUCHIT_ILI_OTKLYUCHIT_MASHTABIROVANIE ;
  MainUnit.MainForm.SendToReport.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_INSTRUMENTOV_PRILOZHENIJ_OTPRAVIT_V_OTCHYETE;
  MainUnit.MainForm.Report.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_INSTRUMENTOV_PRILOZHENIJ_SOZDAT_ITOGOVYJ_OTCHYET;
  MainUnit.MainForm.Help.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_INSTRUMENTOV_PRILOZHENIJ_RUKOVODSTVO_POLZOVATELYA;
  MainUnit.MainForm.PanelInformation.HelpContext:=TypeUnit.IDH_CONTROL_GLAVNOE_OKNO_PANEL__INFORMATSIYA_;
  MainUnit.MainForm.MemoInformation.HelpContext:=TypeUnit.IDH_TOPIC_PRIMER_POYAVLENIYA_INFORMATSII_V_PANELI__INFORMATSIYA_;
  MainUnit.MainForm.NameLabel.HelpContext:=TypeUnit.IDH_CONTROL_GLAVNOE_OKNO_PANEL__OTOBRAZHENIYA_VREMENNYKH_OTSENKAKH_;
  MainUnit.MainForm.Timetraced.HelpContext:=TypeUnit.IDH_CONTROL_GLAVNOE_OKNO_PANEL__OTOBRAZHENIYA_VREMENNYKH_OTSENKAKH_;
  MainUnit.MainForm.PanelVerificationConstruction.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__PROVERKA_POSTROENIYA_;
  MainUnit.MainForm.ControlFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PROVERKA_POSTROENIYA__REDAKTIROVAT_POLE__FUNKTSIYA_PROVERKI_;
  MainUnit.MainForm.GenerateFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PROVERKA_POSTROENIYA__KNOPKA__GENERATSIYA_;
  MainUnit.MainForm.TraceControlFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PROVERKA_POSTROENIYA__KNOPKA__POSTROIT_;
  MainUnit.MainForm.ClearControlFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PROVERKA_POSTROENIYA__KNOPKA__UDALIT_;
  MainUnit.MainForm.HistoryPanel.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__ISTORIYA_ISPOLZOVANNYKH_STRUKTUROOBRAZUYUSHCHIKH_FUNKTSII_;
  MainUnit.MainForm.ActiveSelectMultiple.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__ISTORIYA_ISPOLZOVANNYKH_STRUKTUROOBRAZUYUSHCHIKH_FUNKTSII__FLAZHOK__PODKLYUCHIT_ILI_OTKLYUCHIT_NESKOLKIE_VYBORY_;
  MainUnit.MainForm.HistoryTranslateFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__ISTORIYA_ISPOLZOVANNYKH_STRUKTUROOBRAZUYUSHCHIKH_FUNKTSII___SPISOK_ISPOLZOVANNYKH_STRUKTUROOBRAZUYUSHCHIKH_FUNKTSII;
  MainUnit.MainForm.DeleteChoosedHistory.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__ISTORIYA_ISPOLZOVANNYKH_STRUKTUROOBRAZUYUSHCHIKH_FUNKTSII__KNOPKA__UDALIT_VYBRANNYE_FUNKTSII_;
  MainUnit.MainForm.ClearHistoryTranslate.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__ISTORIYA_ISPOLZOVANNYKH_STRUKTUROOBRAZUYUSHCHIKH_FUNKTSII__KNOPKA__UDALIT_VSYU_ISTORIYU_;
  MainUnit.MainForm.PanelZoom.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__MASSHTABIROVANIE_;
  //MainUnit.MainForm.ActiveScale.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__MASSHTABIROVANIE__FLAZHOK__SDVIG_EHKRANA_;
  MainUnit.MainForm.PZoom.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__MASSHTABIROVANIE__PANEL__ZUM_;
  MainUnit.MainForm.ResetZoomAndScale.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__MASSHTABIROVANIE__PANEL__ZUM_;
  MainUnit.MainForm.PanelExitData.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__VYVOD_DANNYKH_;
  MainUnit.MainForm.LaGrange.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__LAGRANZH_;
  MainUnit.MainForm.CheckBoxLagrangeFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__LAGRANZH__FLAZHOK__POSTROIT_ILI_SKRYT_LAGRANZH_;
  MainUnit.MainForm.CheckBoxErrorLagrangeFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__LAGRANZH__FLAZHOK__POSTROIT_ILI_SKRYT_FUNKTSIYU_OSHIBKI_  ;
  MainUnit.MainForm.LagrangeAccuracy.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__LAGRANZH__POLYA__POGRESHNOST_;
  MainUnit.MainForm.GeneralizingLagrange.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__OBOBSHCHYENNYE_FUNKTSII_LAGRANZHA_;
  MainUnit.MainForm.GeneralizingLagrangeI.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__PERVYJ_VID_OBOBSHCHYENNOJ_FUNKTSII_LAGRANZH_;
  MainUnit.MainForm.CheckBoxGeneralizingFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PERVYJ_VID_OBOBSHCHYENNOJ_FUNKTSII_LAGRANZH__FLAZHOK__POSTROIT_ILI_SKRYT_OBOBSHCHYENNUYU_;
  MainUnit.MainForm.CheckBoxErrorGeneralizingFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PERVYJ_VID_OBOBSHCHYENNOJ_FUNKTSII_LAGRANZH__FLAZHOK__POSTROIT_ILI_SKRYT_FUNKTSIYU_OSHIBKI_;
  MainUnit.MainForm.GeneralisedAccuracy.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PERVYJ_VID_OBOBSHCHYENNOJ_FUNKTSII_LAGRANZH__POLYA___POGRESHNOST_;
  MainUnit.MainForm.GeneralizingLagrangeII.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__VTOROJ_VID_OBOBSHCHYENNOJ_FUNKTSII_LAGRANZH_;
  MainUnit.MainForm.CheckboxGeneralizingFunctionII.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VTOROJ_VID_OBOBSHCHYENNOJ_FUNKTSII_LAGRANZH__FLAZHOK__POSTROIT_ILI_SKRYT_OBOBSHCHYENNUYU_;
  MainUnit.MainForm.CheckboxErrorGeneralizingFunctionII.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VTOROJ_VID_OBOBSHCHYENNOJ_FUNKTSII_LAGRANZH__FLAZHOK__POSTROIT_ILI_SKRYT_FUNKTSIYU_OSHIBKI_;
  MainUnit.MainForm.GeneralisedAccuracyII.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VTOROJ_VID_OBOBSHCHYENNOJ_FUNKTSII_LAGRANZH__POLYA__POGRESHNOST_;
  MainUnit.MainForm.PanelViewFormule.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__FORMULY_;
  MainUnit.MainForm.CheckBoxViewLagrangeFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__FORMULY__FLAZHOK__POKAZAT_ILI_SKRYT_LAGRANZH_;
  MainUnit.MainForm.CheckBoxViewGeneralizingFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__FORMULY__FLAZHOK__POKAZAT_ILI_SKRYT_PERVYJ_VID_OBOBSHCHYENNOJ_FORMULY_;
  MainUnit.MainForm.CheckBoxViewGeneralizingFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__FORMULY__FLAZHOK__POKAZAT_ILI_SKRYT_VTOROJ_VID_OBOBSHCHYENNOJ_FORMULY_;
  MainUnit.MainForm.ClearAllData.HelpContext:=TypeUnit.IDH_CONTROL_GLAVNOE_OKNO_KNOPKA__SBROSIT_VSYE__;
  MainUnit.MainForm.PanelEnterData.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__VVOD_DANNYKH_;
  MainUnit.MainForm.ActiveEnterDataWithPoints.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VVOD_DANNYKH__FLAZHOK__ZADANIE_KOORDINATY_;
  MainUnit.MainForm.ActiveEnterDataWithFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VVOD_DANNYKH__FLAZHOK__ZADANIE_FUNKTSII_;
  MainUnit.MainForm.ActiveEnterDatawithMouse.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VVOD_DANNYKH__FLAZHOK__ZADANIE_KOORDINATY_C_MYSHKOJ_;
  MainUnit.MainForm.ActiveMovingAddPoint.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VVOD_DANNYKH__FLAZHOK__PODKLYUCHIT_ILI_OTKLYUCHIT_PEREMESHCHENIE_TOCHKI_;
  MainUnit.MainForm.TranslateFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VVOD_DANNYKH__REDAKTIROVAT_POLE__STRUKTUROOBRAZUYUSHCHAYA_FUNKTSIYA_;
  MainUnit.MainForm.ViewTranslateFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VVOD_DANNYKH__KNOPKA__POSMOTRET_CTRUKTUROOBRAZUYUSHUYU_FUNKTSIYU_;
  MainUnit.MainForm.PanelEnterDataWithPoints.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__PARAMETRY_TOCHKI_;
  MainUnit.MainForm.AbscissX.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_TOCHKI__REDAKTIROVAT_POLE__ABSTSISSA_KH_;
  MainUnit.MainForm.OrdinateY.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_TOCHKI__REDAKTIROVAT_POLE__ORDINAT_U_;
  MainUnit.MainForm.PointChoosen.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_TOCHKI__FLAZHOK__VYBRAN_;
  MainUnit.MainForm.ViewNode.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_TOCHKI__SKRYT_ILI_POKAZAT_TABLITSU_UZLOV;
  MainUnit.MainForm.AddPoint.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_TOCHKI__KNOPKA__DOBAVIT_;
  MainUnit.MainForm.ModifyPoint.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_TOCHKI__KNOPKA__IZMENIT_;
  MainUnit.MainForm.RemovePoint.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_TOCHKI__KNOPKA__UDALIT_;
  MainUnit.MainForm.ClearAllPoints.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_TOCHKI__KNOPKA__UDALIT_VSE_TOCHKI_;
  MainUnit.MainForm.PanelEnterDataWithFunction.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__PARAMETRY_FUNKTSII_;
  MainUnit.MainForm.IntervalA.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_FUNKTSII__REDAKTIROVAT_POLE__LEVAYA_GRANITSA_;
  MainUnit.MainForm.IntervalB.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_FUNKTSII__REDAKTIROVAT_POLE__PRAVAYA_GRANITSA_;
  MainUnit.MainForm.UsersAnalytiqueFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_FUNKTSII__REDAKTIROVAT_POLE__FUNKTSIYA_;
  MainUnit.MainForm.TraceUsersAnalytiqueFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_FUNKTSII__KNOPKA__POSTROIT_;
  MainUnit.MainForm.ClearUsersAnalytiqueFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_FUNKTSII__KNOPKA__UDALIT_;
  MainUnit.MainForm.AddPointWithFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__PARAMETRY_FUNKTSII__KNOPKA__DOBAVIT_TOCHKI_FUNKTSII_;
  MainUnit.MainForm.DeplacePointEnterData.HelpContext:=TypeUnit.IDH_TOPIC_PANEL_POSHAGOVOGO_PEREMESHCHENIYA_TOCHKI_PO_KRIVOJ;
  MainUnit.MainForm.Delta.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_POSHAGOVOGO_PEREMESHCHENIYA_TOCHKI_PO_KRIVOJ_SHAG_PEREMESHCHENIYA;
  MainUnit.MainForm.Minus.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_POSHAGOVOGO_PEREMESHCHENIYA_TOCHKI_PO_KRIVOJ_KNOPKA_____1;
  MainUnit.MainForm.Plus.HelpContext:=TypeUnit.IDH_CONTROL_PANEL_POSHAGOVOGO_PEREMESHCHENIYA_TOCHKI_PO_KRIVOJ_KNOPKA_____2;
  MainUnit.MainForm.StringGrid1.HelpContext:=TypeUnit.IDH_TOPIC_TABLITSA_UZLOV_INTERPOLYATSII;
  MainUnit.MainForm.Chart.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__RABOCHIJ_EHKRAN_GRAFIK_;
  MainUnit.MainForm.ResizeChart.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__RABOCHIJ_EHKRAN_GRAFIK__KNOPKA__VOSSTANOVIT_EHKRAN_;
  MainUnit.MainForm.DrawAxisX.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__RABOCHIJ_EHKRAN_GRAFIK__FLAZHOK__POKAZAT_ILI_SKRYT_OS_X_;
  MainUnit.MainForm.DrawAxisY.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__RABOCHIJ_EHKRAN_GRAFIK__FLAZHOK__POKAZAT_ILI_SKRYT_OS_Y_;
  MainUnit.MainForm.SetValueInsetting.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__RABOCHIJ_EHKRAN_GRAFIK__KNOPKA__ZAFIKSIROVAT_TEKUSHCHIJ_RAZMER_EHKRANA_;
  MainUnit.MainForm.DistinctionWithResize.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYDELENIYA_FUNKTSIJ__FLAZHOK__S_IZMENENIEM_RAZMERA_EHKRANA_POD_FUNKTSII_;
  MainUnit.MainForm.HideFunction.HelpContext:=TypeUnit.IDH_TOPIC_RASKRYVAYUSHCHIJSYA_SPISOK__POKAZAT_ILI_SKRYT_VYDELENNYKH_FUNKTSII_;
  TypeUnit.PanelDistinction.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__VYDELENIYA_FUNKTSIJ_;
  for I := 0 to TypeUnit.QCheck do TypeUnit.CheckDistinction[i].HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYDELENIYA_FUNKTSIJ__FLAZHKI_VYDELENIYA;
  SettingUnit.SettingForm.HelpContext:=TypeUnit.IDH_TOPIC_OKNO_NASTROJKI;
  SettingUnit.SettingForm.Language.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__YAZYK_;
  SettingUnit.SettingForm.ChooseLanguage.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__YAZYK_;
  SettingUnit.SettingForm.RoundValue.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_REDAKTIROVANIE_POLYA__ZNACHENIYA_OKRUGLENIYA_;
  SettingUnit.SettingForm.Precision.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_REDAKTIROVANIE_POLYA__TOCHNOST_;
  SettingUnit.SettingForm.EnterData.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__VVODNYE_DANNYE_;
  SettingUnit.SettingForm.StepTraceUsersAnalytiqueFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VVODNYE_DANNYE__IZMENIT_POLE__SHAG_POSTROENIYA_POLZOVATELSKOJ_FUNKTSII_;
  SettingUnit.SettingForm.StepTraceLagrangeAndGeneralizingFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VVODNYE_DANNYE__IZMENIT_POLE__SHAG_POSTROENIYA_LAGRANZHA_I_EYE_OBOBSHCHENNYKH_;
  SettingUnit.SettingForm.StepTraceErrorFunction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VVODNYE_DANNYE__IZMENIT_POLE__SHAG_POSTROENIYA_FUNKTSIJ_OSHIBOK_;
  SettingUnit.SettingForm.ExitData.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__VYVODNYE_DANNYE__;
  SettingUnit.SettingForm.AxisX.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___PANEL__OS_KH_;
  SettingUnit.SettingForm.AxisXLeftValue.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___IZMENIT_POLE__MIN__2;
  SettingUnit.SettingForm.AxisXRightValue.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___IZMENIT_POLE__MAKH__2;
  SettingUnit.SettingForm.AxisY.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___PANEL__OS_Y_;
  SettingUnit.SettingForm.AxisYLeftValue.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___IZMENIT_POLE__MIN__1;
  SettingUnit.SettingForm.AxisYRightValue.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___IZMENIT_POLE__MAKH__1;
  SettingUnit.SettingForm.PanelMarge.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___PANEL__POLYA_IZOBRAZHENIYA_GRAFIKOV_;
  SettingUnit.SettingForm.MargeX.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___IZMENIT_POLE__PO_KH_;
  SettingUnit.SettingForm.MargeY.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___IZMENIT_POLE__PO_Y_;
  SettingUnit.SettingForm.Distinction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___PANEL__TOLSHCHINA_VYDELENIYA_;
  SettingUnit.SettingForm.PenWidthDistincted.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___IZMENIT_POLE__TOLSHCHINA_NE_VYDELENNYKH_;
  SettingUnit.SettingForm.PenWidthNotDistincted.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__VYVODNYE_DANNYE___IZMENIT_POLE__TOLSHCHINA_VYDELENNYKH_;
  SettingUnit.SettingForm.Report.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveEnterDataWithFunction.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveEnterDataPoints.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveExitDataFormules.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveGraphe.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveTableValueTracedUsersAnalytiqueFunction.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveTableValueTracedLaGrangeFunction.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveTableValueTracedGeneralizingFunction.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveTableValueTracedGeneralizingFunctionII.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveControlFunction.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.GroupActiveGraph.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveGraphUserFunction.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveGraphLagrange.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveGraphLagrangeError.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveGraphGeneralisedLagrange.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeError.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeII.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveGraphGeneralisedLagrangeErrorII.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.ActiveGraphControlFunction.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__VKLYUCHIT_V_VREMENNOM_OTCHYETE_;
  SettingUnit.SettingForm.CreateReportPanel.HelpContext:=TypeUnit.IDH_TOPIC_PANEL__SOZDAT_ITOGOVYJ_OTCHYET_;
  SettingUnit.SettingForm.Withoutrestriction.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__SOZDAT_ITOGOVYJ_OTCHYET__FLAZHOK__BEZ_VREMENNYKH_OGRANICHENIJ_ILI_S_VREMENNYMI_OGRANICHENIYAMI_;
  SettingUnit.SettingForm.DateTimeReport.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__SOZDAT_ITOGOVYJ_OTCHYET__PANEL__USTANOVKA_VREMENNYKH_OGRANICHENIJ_;
  SettingUnit.SettingForm.DatePickerFrom.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__SOZDAT_ITOGOVYJ_OTCHYET__NACHALNAYA_DATA_I_NACHALNOE_VREMYA;
  SettingUnit.SettingForm.DatePickerTo.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__SOZDAT_ITOGOVYJ_OTCHYET__FINALNAYA_DATA_I_FINALNOE_VREMYA;
  SettingUnit.SettingForm.TimePickerFrom.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__SOZDAT_ITOGOVYJ_OTCHYET__NACHALNAYA_DATA_I_NACHALNOE_VREMYA;
  SettingUnit.SettingForm.TimePickerTo.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__SOZDAT_ITOGOVYJ_OTCHYET__FINALNAYA_DATA_I_FINALNOE_VREMYA;
  SettingUnit.SettingForm.ResetDateTime.HelpContext:=TypeUnit.IDH_CONTROL_PANEL__SOZDAT_ITOGOVYJ_OTCHYET__KNOPKA__CBROSIT_;
  SettingUnit.SettingForm.HistoryPanel.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__ISTORIYA_ISPOLZOVANNYKH_STRUKTUROOBRAZUYUSHCHIKH_FUNKTSII_;
  SettingUnit.SettingForm.depthofhistory.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_PANEL__ISTORIYA_ISPOLZOVANNYKH_STRUKTUROOBRAZUYUSHCHIKH_FUNKTSII_;
  SettingUnit.SettingForm.SetDefaultSetting.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_NASTROJKI_KNOPKA__NASTROJKA_PO_UMOLCHANIYU_;
  ShowTranslateFunctionUnit.TranslateFunctionForm.HelpContext:=TypeUnit.IDH_TOPIC_OKNO_STRUKTUROOBRAZUYUSHCHEJ_FUNKTSII;
  ShowTranslateFunctionUnit.TranslateFunctionForm.Chart1.HelpContext:=TypeUnit.IDH_CONTROL_OKNO_STRUKTUROOBRAZUYUSHCHEJ_FUNKTSII_RABOCHIJ_EHKRAN_GRAFIK;

end;

end.