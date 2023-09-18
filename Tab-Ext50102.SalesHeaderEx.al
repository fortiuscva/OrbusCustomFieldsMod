tableextension 50102 SalesHeaderEx extends "Sales Header"
{
    fields
    {
        field(50102; "Order Status"; Enum OrderStatus)
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Status';

            trigger OnValidate()
            var
                userSetup: Record "User Setup";
                GetDimSetValues: Codeunit GetDimSetValues;
                SalesLine: Record "Sales Line";
                DimensionSetEntry: Record "Dimension Set Entry";
                ModLocationCodeHeader: Codeunit ModLocationCodeHeader;
            begin
                if (Rec."Document Type" = Rec."Document Type"::Order) or (Rec."Document Type" = Rec."Document Type"::Quote) or (Rec."Document Type" = Rec."Document Type"::"Return Order") then begin
                    ModLocationCodeHeader.InsertDimensionSetEntryFromSalesHeader(Rec);
                    SalesLine.Reset();
                    SalesLine.SetRange("Document No.", Rec."No.");
                    if SalesLine.FindSet() then
                        repeat
                            DimensionSetEntry.Reset();
                            DimensionSetEntry.SetRange("Dimension Set ID", SalesLine."Dimension Set ID");
                            DimensionSetEntry.SetFilter("Dimension Code", 'LOC');
                            if DimensionSetEntry.FindFirst() then
                                exit
                            else
                                GetDimSetValues.GetDimSetValues(SalesLine."Shortcut Dimension 1 Code", SalesLine."Dimension Set ID");
                        until SalesLine.Next() = 0;
                end;
            end;
        }
        field(50103; "Location Override"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Location Override';
        }
        field(55103; "Industry Shortcut Dimension"; Text[100])
        {
        }
        field(60200; "Project No."; Text[1000])
        {
            DataClassification = CustomerContent;
        }
        field(60201; "Approval Deadline"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60202; "Production Scan Time"; DateTime)
        {
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                setLocationCodeUnit: Codeunit "ORBAPP Set Location";
                salesLine: Record "Sales Line";
                salesHeader: Record "Sales Header";
                DimSetEntry: Record "Dimension Set Entry";
                TempDimSetEntry: Record "Dimension Set Entry" temporary;
                ModLocationCodeHeader: Codeunit ModLocationCodeHeader;
                DimMgt: Codeunit DimensionManagement;
            begin
                /*
                salesHeader.Reset();
                salesHeader.SetRange("No.", Rec."No.");
                if salesHeader.FindFirst()then begin
                    salesLine.Reset();
                    salesLine.SetRange("Document No.", Rec."No.");
                    if salesLine.FindSet()then begin
                        salesLine.ModifyAll("Location Code", Rec."Location Code");
                        salesLine.ModifyAll("Shortcut Dimension 1 Code", Rec."Location Code");
                    end;
                    Rec."Shortcut Dimension 1 Code":=Rec."Location Code";
                    Rec.Modify();
                    ModLocationCodeHeader.Run(Rec);
                    ModLocationCodeHeader.ModifyDimSetEntry2(Rec);
                end;
                */
                if Rec."Location Code" <> '' then
                    Rec.Validate("Shortcut Dimension 1 Code", Rec."Location Code");



                salesLine.Reset();
                salesLine.SetRange("Document Type", Rec."Document Type");
                salesLine.SetRange("Document No.", Rec."No.");
                if salesLine.FindSet() then
                    repeat
                        salesLine.Validate("Location Code", rec."Location Code");
                        //if salesLine."Location Code" <> '' then
                        //salesLine.validate("Shortcut Dimension 1 Code", salesLine."Location Code");
                        salesLine.Modify();
                    until salesLine.Next() = 0;
            end;
        }
        modify("Ship-to County")
        {
            trigger OnAfterValidate()
            var
                OrbusLocation: Record OrbusLocations;
                DimensionsetEntry: Record "Dimension Set Entry";
                DimensionValue: Record "Dimension Value";
                ModLocationCodeHeader: Codeunit ModLocationCodeHeader;
            begin
                if StrLen(Rec."Ship-to County") > 2 then Rec."Ship-to County" := CopyStr(Rec."Ship-to County", 1, 2);
                Rec."Ship-to County" := UpperCase(Rec."Ship-to County");
                Rec.Modify();
                OrbusLocation.Reset();
                OrbusLocation.SetRange("Orbus State Text", Rec."Ship-to County");
                if OrbusLocation.FindFirst() then begin
                    Rec."Location Code" := OrbusLocation.OrbusLocation;
                    Rec."Shortcut Dimension 1 Code" := OrbusLocation.OrbusLocation;
                    Rec.Modify();
                    SalesLine.Reset();
                    SalesLine.SetRange("Document No.", Rec."No.");
                    if SalesLine.FindSet() then begin
                        SalesLine.ModifyAll(SalesLine."Location Code", OrbusLocation.OrbusLocation);
                        SalesLine.ModifyAll(SalesLine."Shortcut Dimension 1 Code", OrbusLocation.OrbusLocation);
                    end;
                    ModLocationCodeHeader.Run(Rec);
                    ModLocationCodeHeader.ModifyDimSetEntry(Rec, OrbusLocation);
                end;
            end;
        }
        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            var
            begin
                GetLocationCodeFromOrbusLocationTable()
            end;
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
            begin
                GetLocationCodeFromOrbusLocationTable()
            end;
        }
    }
    trigger OnAfterInsert()
    var
    begin
        if (Rec."Sell-to Customer No." <> '') then //     // setLocationCodeUnit.SetOrbusLocation(Rec);
            SetLocation(false);
    end;

    trigger OnAfterModify()
    var
    begin
        // if (Rec."Location Code" = '') then // SAR 02.24.23 - Reinserted this check.
        //     setLocationCodeUnit.SetOrbusLocation(Rec);
        SetLocation(true);
    end;

    procedure SetLocation(isModify: Boolean)
    var
        setLocationCodeUnit: Codeunit "ORBAPP Set Location";
    begin
        if (Rec."Sell-to Customer No." = '') then exit;
        if isModify then
            if (Rec."Location Override" = true) then // SAR 02.24.23 - Reinserted this check.
                exit;
        setLocationCodeUnit.SetOrbusLocation(Rec);
    end;

    procedure GetLocationCodeFromOrbusLocationTable()
    var
        OrbusLocation: Record OrbusLocations;
        var1: Text;
        DimensionSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
    begin
        if (Rec."Document Type" = Rec."Document Type"::Order) or (Rec."Document Type" = Rec."Document Type"::Quote) or (Rec."Document Type" = Rec."Document Type"::"Return Order") then begin
            OrbusLocation.Reset();
            OrbusLocation.SetRange("Orbus State Text", Rec."Ship-to County");
            if OrbusLocation.FindFirst() then begin
                Rec."Location Code" := OrbusLocation.OrbusLocation;
                Rec."Shortcut Dimension 1 Code" := OrbusLocation.OrbusLocation;
                /*Rec.Modify();*/
            end;
        end;
    end;
}
