tableextension 50104 ORBAPPSalesLineEx extends "Sales Line"
{
    fields
    {
        field(60100; "Hardware Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60101; "Graphics Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        /*modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                GetValues: Codeunit GetDimSetValues;
            begin
                if
                (Rec."Document Type" = Rec."Document Type"::Order) or (Rec."Document Type" = Rec."Document Type"::Quote) or (Rec."Document Type" = Rec."Document Type"::"Return Order")
                then
                    GetValues.GetDimSetValues(Rec."Shortcut Dimension 1 Code", Rec."Dimension Set ID");
            end;
        }*/
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                ModLocationCode: Codeunit ModLocationCode;
            begin
                /*
                ModLocationCode.Run(Rec)
                */
                if Rec."Location Code" <> '' then
                    rec.validate("Shortcut Dimension 1 Code", rec."Location Code")
                else begin
                    if rec."Shortcut Dimension 1 Code" <> '' then
                        Validate("Shortcut Dimension 1 Code", '');
                end;
                //ValidateShortcutDimCode(1, rec."Location Code");
            end;
        }
    }
    trigger OnAfterInsert()
    var
        SalesHeader: Record "Sales Header";
        GetValues: Codeunit GetDimSetValues;
        SalesLine: Record "Sales Line";
        var10: Integer;
    begin
        if (Rec."Document Type" = Rec."Document Type"::Order) or (Rec."Document Type" = Rec."Document Type"::Quote) or (Rec."Document Type" = Rec."Document Type"::"Return Order") then begin
            SalesHeader.Reset();
            SalesHeader.SetRange("No.", Rec."Document No.");
            if SalesHeader.FindFirst() then begin
                Rec."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
                Rec."Location Code" := SalesHeader."Location Code";
                Rec.Modify();
            end;
        end;
    end;

    trigger OnAfterModify()
    begin
        SetHardwareGraphicsPrice();
    end;

    procedure SetHardwareGraphicsPrice()
    var
        VariantRec: Record "Item Variant";
        SalesPriceRec: Record "Sales Price";
    begin
        Rec."Hardware Price" := 0;
        Rec."Graphics Price" := 0;
        if Rec."Variant Code" <> '' then VariantRec.Get(Rec."No.", Rec."Variant Code");
        if Rec."Customer Price Group" = '' then exit;
        if Rec.Quantity = 0 then exit;
        case true OF
            Rec."Shortcut Dimension 2 Code" = '01':
                begin
                    Rec."Hardware Price" := Rec."Unit Price";
                end;
            Rec."Shortcut Dimension 2 Code" = '02':
                begin
                    Rec."Graphics Price" := Rec."Unit Price";
                end;
            (Rec."Shortcut Dimension 2 Code" = '03') AND (VariantRec.Code = 'HARDWARE'):
                begin
                    Rec."Hardware Price" := Rec."Unit Price";
                end;
            (Rec."Shortcut Dimension 2 Code" = '03') AND (VariantRec.Code <> 'HARDWARE'):
                begin
                    SalesPriceRec.reset;
                    SalesPriceRec.SetRange("Item No.", Rec."No.");
                    SalesPriceRec.SetRange("Variant Code", 'HARDWARE');
                    SalesPriceRec.Setrange("Sales Type", SalesPriceRec."Sales Type"::"Customer Price Group");
                    SalesPriceRec.SetRange("Sales Code", Rec."Customer Price Group");
                    SalesPriceRec.SetFilter("Minimum Quantity", '..%1', Rec."Quantity");
                    if SalesPriceRec.FindLast() then begin
                        Rec."Hardware Price" := SalesPriceRec."Unit Price";
                        Rec."Graphics Price" := Rec."Unit Price" - Rec."Hardware Price";
                    end;
                end;
        end;
    end;

    var
        LineNoVar: Integer;
}
