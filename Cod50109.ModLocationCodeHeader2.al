codeunit 50109 ModLocationCodeHeader2
{
    Permissions = tabledata "Sales Header"=RIMD;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Salesheader: Record "Sales Header";
        dimensionsetentry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
    begin
        Salesheader.Reset();
        Salesheader.SetRange("Document Type", Salesheader."Document Type"::Order);
        if Salesheader.FindSet()then repeat dimensionsetentry.Reset();
                dimensionsetentry.SetRange("Dimension Set ID", Salesheader."Dimension Set ID");
                dimensionsetentry.SetFilter("Dimension Code", 'LOC');
                if dimensionsetentry.FindFirst()then exit
                else
                begin
                    DimensionValue.Reset();
                    DimensionValue.SetFilter("Dimension Code", 'LOC');
                    DimensionValue.SetRange(Code, Salesheader."Location Code");
                    if DimensionValue.FindFirst()then begin
                        dimensionsetentry.Init();
                        dimensionsetentry."Dimension Set ID":=Salesheader."Dimension Set ID";
                        dimensionsetentry."Dimension Code":='LOC';
                        dimensionsetentry."Dimension Name":='Location';
                        dimensionsetentry."Dimension Value Code":=DimensionValue.Code;
                        dimensionsetentry."Dimension Value ID":=DimensionValue."Dimension Value ID";
                        dimensionsetentry."Dimension Value Name":=DimensionValue.Name;
                        dimensionsetentry."Global Dimension No.":=DimensionValue."Global Dimension No.";
                        dimensionsetentry.Insert();
                    end;
                end;
            until Salesheader.Next() = 0;
    end;
}
