codeunit 60103 ModifyGLEntries
{
    Permissions = tabledata "G/L Entry" = RIMD;
    TableNo = "Job Queue Entry";

    //DimFix
    trigger OnRun()
    var
        GLEntry: Record "G/L Entry";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCreditMemoHeader: Record "Sales Cr.Memo Header";
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        var1: Text;
        GLDocNo: Text;
    begin
        GLEntry.Reset();
        GLEntry.SetFilter("G/L Account No.", '40000..40009|41000..41999|50000..59999');
        if GLEntry.FindSet() then
            repeat
                GLDocNo := Format(GLEntry."Document No.");
                if GLEntry."Location Code" = '' then begin
                    if (GLDocNo.StartsWith('PS-CR')) or (GLDocNo.StartsWith('PPCR')) then begin
                        SalesCreditMemoHeader.Reset();
                        SalesCreditMemoHeader.SetRange("No.", GLEntry."Document No.");
                        if SalesCreditMemoHeader.FindFirst() then begin
                            GLEntry."Location Code" := SalesCreditMemoHeader."Location Code";
                            GLEntry.Modify();
                        end;
                    end;
                    if (GLDocNo.StartsWith('PS-INV')) then begin
                        SalesInvoiceHeader.Reset();
                        SalesInvoiceHeader.SetRange("No.", GLEntry."Document No.");
                        if SalesInvoiceHeader.FindFirst() then begin
                            GLEntry."Location Code" := SalesInvoiceHeader."Location Code";
                            GLEntry.Modify();
                        end;
                    end;
                    if GLDocNo.StartsWith('PPINV') then begin
                        PurchaseInvoiceHeader.Reset();
                        PurchaseInvoiceHeader.SetRange("No.", GLEntry."Document No.");
                        if PurchaseInvoiceHeader.FindFirst() then begin
                            GLEntry."Location Code" := PurchaseInvoiceHeader."Location Code";
                            GLEntry.Modify();
                        end;
                    end;
                    if GLDocNo.StartsWith('S-PSHP') then begin
                        SalesShipmentHeader.Reset();
                        SalesShipmentHeader.SetRange("No.", GLEntry."Document No.");
                        if SalesShipmentHeader.FindFirst() then begin
                            GLEntry."Location Code" := SalesShipmentHeader."Location Code";
                            GLEntry.Modify();
                        end;
                    end;
                end;
            until GLEntry.Next() = 0;
    end;
}
