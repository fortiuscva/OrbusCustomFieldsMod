codeunit 50105 ModLocationCode
{
    Permissions = tabledata "Dimension Set Entry"=RIMD;
    TableNo = "Sales Line";

    trigger OnRun()
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
    begin
        if(Rec."Document Type" = Rec."Document Type"::Order) or (Rec."Document Type" = Rec."Document Type"::Quote) or (Rec."Document Type" = Rec."Document Type"::"Return Order")then begin
            Rec."Shortcut Dimension 1 Code":=Rec."Location Code";
            Rec.Modify();
            DimensionSetEntry.Reset();
            DimensionSetEntry.SetRange("Dimension Set ID", Rec."Dimension Set ID");
            DimensionSetEntry.SetFilter("Dimension Code", 'LOC');
            if DimensionSetEntry.FindFirst()then begin
                DimensionValue.Reset();
                DimensionValue.SetFilter("Dimension Code", 'LOC');
                DimensionValue.SetRange(Code, Rec."Location Code");
                if DimensionValue.FindFirst()then begin
                    DimensionSetEntry."Dimension Value Code":=Rec."Location Code";
                    DimensionSetEntry."Dimension Value Name":=DimensionValue.Name;
                    DimensionSetEntry."Dimension Value ID":=DimensionValue."Dimension Value ID";
                    DimensionSetEntry.Modify();
                end;
            end;
        end;
    end;
}
