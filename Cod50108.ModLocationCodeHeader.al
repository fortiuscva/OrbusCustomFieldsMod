codeunit 50108 ModLocationCodeHeader
{
    Permissions = tabledata "Dimension Set Entry" = RIMD;
    TableNo = "Sales Header";

    trigger OnRun()
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", Rec."No.");
        if SalesLine.FindSet() then
            repeat
                DimensionsetEntry.Reset();
                DimensionsetEntry.SetRange("Dimension Set ID", SalesLine."Dimension Set ID");
                DimensionsetEntry.SetFilter("Dimension Code", 'LOC');
                if DimensionsetEntry.FindFirst() then begin
                    DimensionValue.Reset();
                    DimensionValue.SetFilter("Dimension Code", 'LOC');
                    DimensionValue.SetRange(Code, SalesLine."Shortcut Dimension 1 Code");
                    if DimensionValue.FindFirst() then begin
                        DimensionsetEntry."Dimension Value Code" := Rec."Shortcut Dimension 1 Code";
                        DimensionsetEntry."Dimension Value Name" := DimensionValue.Name;
                        DimensionsetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                        DimensionsetEntry.Modify();
                    end;
                end;
            until SalesLine.Next() = 0;
    end;

    procedure InsertDimensionSetEntryFromSalesHeader(Var1: Record "Sales Header")
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
    begin
        DimensionSetEntry.Reset();
        DimensionSetEntry.SetRange("Dimension Set ID", Var1."Dimension Set ID");
        DimensionSetEntry.SetFilter("Dimension Code", 'LOC');
        if DimensionSetEntry.FindFirst() then begin
            DimensionValue.Reset();
            DimensionValue.SetFilter("Dimension Code", 'LOC');
            DimensionValue.SetRange(Code, Var1."Location Code");
            if DimensionValue.FindFirst() then begin
                DimensionSetEntry."Dimension Value Code" := Var1."Location Code";
                DimensionSetEntry."Dimension Value Name" := DimensionValue.Name;
                DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                DimensionSetEntry.Modify();
            end;
        end
        else begin
            DimensionSetEntry.Reset();
            DimensionValue.Reset();
            DimensionValue.SetFilter("Dimension Code", 'LOC');
            DimensionValue.SetRange(Code, Var1."Location Code");
            if DimensionValue.FindFirst() then begin
                DimensionSetEntry.Init();
                DimensionSetEntry."Dimension Set ID" := Var1."Dimension Set ID";
                DimensionSetEntry."Dimension Code" := 'LOC';
                DimensionSetEntry."Dimension Value Code" := Var1."Location Code";
                DimensionSetEntry."Dimension Value Name" := DimensionValue.Name;
                DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                DimensionSetEntry.Insert();
            end;
        end;
    end;

    procedure ModifyDimSetEntry(Var1: Record "Sales Header"; Var2: Record OrbusLocations)
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
    begin
        DimensionsetEntry.Reset();
        DimensionsetEntry.SetRange("Dimension Set ID", Var1."Dimension Set ID");
        DimensionsetEntry.SetFilter("Dimension Code", 'LOC');
        if DimensionsetEntry.FindFirst() then begin
            DimensionValue.Reset();
            DimensionValue.SetFilter("Dimension Code", 'LOC');
            DimensionValue.SetRange(Code, Var2.OrbusLocation);
            if DimensionValue.FindFirst() then begin
                DimensionsetEntry."Dimension Value Code" := Var2.OrbusLocation;
                DimensionsetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                DimensionsetEntry."Dimension Value Name" := DimensionValue.Name;
                DimensionsetEntry.Modify();
            end;
        end;
    end;

    procedure ModifyDimSetEntry2(Var1: Record "Sales Header")
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
    begin
        DimensionsetEntry.Reset();
        DimensionsetEntry.SetRange("Dimension Set ID", Var1."Dimension Set ID");
        DimensionsetEntry.SetFilter("Dimension Code", 'LOC');
        if DimensionsetEntry.FindFirst() then begin
            DimensionValue.Reset();
            DimensionValue.SetFilter("Dimension Code", 'LOC');
            DimensionValue.SetRange(Code, Var1."Location Code");
            if DimensionValue.FindFirst() then begin
                DimensionsetEntry."Dimension Value Code" := Var1."Location Code";
                DimensionsetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                DimensionsetEntry."Dimension Value Name" := DimensionValue.Name;
                DimensionsetEntry.Modify();
            end;
        end;
    end;

    procedure InsertDimSetEntryFromSalesOrderList()
    var
        Salesheader: Record "Sales Header";
        dimensionsetentry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
    begin
        Salesheader.Reset();
        Salesheader.SetRange("Document Type", Salesheader."Document Type"::Order);
        if Salesheader.FindSet() then
            repeat
                dimensionsetentry.Reset();
                dimensionsetentry.SetRange("Dimension Set ID", Salesheader."Dimension Set ID");
                dimensionsetentry.SetFilter("Dimension Code", 'LOC');
                if dimensionsetentry.FindFirst() then
                    exit
                else begin
                    DimensionValue.Reset();
                    DimensionValue.SetFilter("Dimension Code", 'LOC');
                    DimensionValue.SetRange(Code, Salesheader."Shortcut Dimension 1 Code");
                    if DimensionValue.FindFirst() then begin
                        dimensionsetentry.Init();
                        dimensionsetentry."Dimension Set ID" := Salesheader."Dimension Set ID";
                        dimensionsetentry."Dimension Code" := 'LOC';
                        dimensionsetentry."Dimension Name" := 'Location';
                        dimensionsetentry."Dimension Value Code" := DimensionValue.Code;
                        dimensionsetentry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                        dimensionsetentry."Dimension Value Name" := DimensionValue.Name;
                        dimensionsetentry."Global Dimension No." := DimensionValue."Global Dimension No.";
                        dimensionsetentry.Insert();
                    end;
                end;
            until Salesheader.Next() = 0;
    end;
}
