codeunit 50103 "ORBAPP Set Location"
{
    [TryFunction]
    local procedure FromStringToEnum(var stateOption: Enum StateOptions; textString: Text);
    var
        StateEnum: Enum StateOptions;
        OrdinalValue: Integer;
        Index: Integer;
        LevelName: Text;
    begin
        if textString = '' then exit;
        Index := StateOptions.Names.IndexOf(textString);
        OrdinalValue := StateOptions.Ordinals.Get(Index);
        StateEnum := Enum::StateOptions.FromInteger(OrdinalValue);
        //StateEnum := Enum::StateOptions.FromInteger(StateEnum.Ordinals.Get(StateEnum.Names.IndexOf(textString)));
        stateOption := StateEnum;
    end;

    //DimFix
    // procedure SetOrbusLocation(var CurrentRecord: Record "Sales Header")
    // var
    //     OrbusLocation: Record OrbusLocations;
    //     StateString: Text;
    //     SalesLine: Record "Sales Line";
    //     salesHeader: Record "Sales Header";
    //     NewLocationCode: Code[20];
    //     StateEnum: Enum StateOptions;
    // begin
    //     if CurrentRecord."Location Override" then exit;
    //     if CurrentRecord."Ship-to County" = '' then exit;
    //     // if CurrentRecord."Document Type" = CurrentRecord."Document Type"::"Return Order" then // SAR 01.27.23 Use Sell-to County on Return Orders (No Ship-to Info).
    //     //    CurrentRecord."Ship-to County" := CurrentRecord."Sell-to County";
    //     StateString:=CurrentRecord."Ship-to County";
    //     CurrentRecord."Ship-to County":=StateString.ToUpper();
    //     CurrentRecord."Ship-to County":=CurrentRecord."Ship-to County".ToUpper(); // SAR 12.01.22 Ship-to and Sell-to must be capitalized.
    //     // if CurrentRecord."Sell-to County" <> '' then begin
    //     // if CurrentRecord."Document Type" = CurrentRecord."Document Type"::"Return Order" then begin
    //     //     OrbusLocation.SetFilter(OrbusState, '=%1', FromStringToEnum(CurrentRecord."Ship-to County"));
    //     // end else begin
    //     //     // if CurrentRecord."Ship-to County" <> CurrentRecord."Sell-to County" then begin
    //     // end;
    //     NewLocationCode:='WR';
    //     if FromStringToEnum(StateEnum, CurrentRecord."Ship-to County")then begin
    //         OrbusLocation.SETRANGE(OrbusState, StateEnum);
    //         if OrbusLocation.FindSet then NewLocationCode:=OrbusLocation.OrbusLocation end;
    //     // SAR 12.05.22 - Current Record = Sales Header Record
    //     if salesHeader.Get(CurrentRecord."Document Type", CurrentRecord."No.")then begin
    //         if NewLocationCode = salesHeader."Location Code" then exit;
    //         salesHeader."Location Code":=NewLocationCode;
    //         salesHeader.validate("Shortcut Dimension 1 Code", NewLocationCode);
    //         salesHeader.Modify(true);
    //     end;
    //     SalesLine.SetRange("Document No.", CurrentRecord."No.");
    //     if SalesLine.FindSet then begin
    //         repeat SalesLine."Location Code":=salesHeader."Location Code";
    //             SalesLine.validate("Shortcut Dimension 1 Code", salesHeader."Location Code");
    //             SalesLine.Modify(true);
    //         until SalesLine.Next = 0;
    //     end;
    // end;
}
