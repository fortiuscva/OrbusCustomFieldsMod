codeunit 60105 "ORB Single Instance"
{
    SingleInstance = true;


    procedure SetDimUpdateFromDimWindow(DimUpdateFromDimWindowPar: Boolean)
    begin
        DimUpdateFromDimWindowGbl := DimUpdateFromDimWindowPar;
    end;

    procedure GetDimUpdateFromDimWindow(): Boolean
    begin
        exit(DimUpdateFromDimWindowGbl);
    end;

    var
        DimUpdateFromDimWindowGbl: Boolean;

}
