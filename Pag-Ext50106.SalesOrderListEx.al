pageextension 50106 SalesOrderListEx extends "Sales Order List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Order Status"; rec."Order Status")
            {
                ApplicationArea = All;
            }
        }
        addafter("External Document No.")
        {
            field("Industry Shortcut Dimension"; Rec."Industry Shortcut Dimension")
            {
                Caption = 'Industry Code';
                ApplicationArea = All;
                Editable = false;
            }
        }
        addbefore("Completely Shipped")
        {
            field("Approval Deadline"; Rec."Approval Deadline")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Approval Deadline';
            }
        }
    }
    actions
    {
        // Add changes to page actions here
        addlast(Action12)
        {
            action("Release & Pick")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category5;
                Image = CreateWarehousePick;

                trigger OnAction()
                var
                    ReleasePick: Codeunit "Create WhseShipment/Pick";
                    SalesHeader: Record "Sales Header";
                    UpdatedOrder: Record "Sales Header";
                begin
                    if (Rec."Shipping Agent Code" = '') and (Rec."Shipping Agent Service Code" = '') then Error('Shipping Agent Code and Shipping Agent Service have a value of "blank". Both fields need a value other than "blank"');
                    if (Rec."Shipping Agent Code" = '') then Error('Shipping Agent Code cannot have a value of "blank"');
                    if Rec."Shipping Agent Service Code" = '' then Error('Shipping Agent Service Code cannot have a value of "blank"');
                    CurrPage.SetSelectionFilter(SalesHeader);
                    SalesHeader.MarkedOnly(true);
                    IF SalesHeader.FindSet() then
                        repeat
                            ReleasePick.CreateWhseShipment_Pick(SalesHeader);
                            UpdatedOrder.get(SalesHeader."Document Type", SalesHeader."No.");
                            UpdatedOrder."Order Status" := UpdatedOrder."Order Status"::"Pick Released";
                            UpdatedOrder.Modify();
                        Until SalesHeader.Next() = 0;
                    CurrPage.Update();
                end;
            }
        }
        addlast("&Print")
        {
            action("Print Work Orders and Production")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category8;
                Image = Print;

                trigger OnAction()
                var
                    ProdHdr: Record "Production Order";
                    SalesHdr: Record "Sales Header";
                    WorkOrder: Report "Work Order";
                begin
                    CurrPage.SetSelectionFilter(SalesHdr);
                    SalesHdr.MarkedOnly(true);
                    Clear(WorkOrder);
                    IF SalesHdr.FindSet() then begin
                        repeat
                            ProdHdr.SetRange("Sales Order No.", SalesHdr."No.");
                            if ProdHdr.FindSet() then
                                repeat
                                    ProdHdr.mark(true);
                                until ProdHdr.Next() = 0;
                        until SalesHdr.Next() = 0;
                        ProdHdr.MarkedOnly(true);
                        WorkOrder.SetTableView(SalesHdr);
                        WorkOrder.UseRequestPage(false);
                        WorkOrder.Runmodal();
                        IF ProdHdr.FindSet() then Report.Runmodal(Report::"Custom Production Order", false, true, ProdHdr);
                    end;
                end;
            }
            action("Export Work Orders to PDF")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category8;
                Image = Print;

                trigger OnAction()
                var
                    saleshdr: Record "Sales Header";
                    PrintHdr: Record "Sales Header";
                    RecRef: RecordRef;
                    oStream: OutStream;
                    TempBlob: Codeunit "Temp Blob";
                    FileManagement: Codeunit "File Management";
                    FldRef: FieldRef;
                    DataCompression: Codeunit "Data Compression";
                    ZipFileName: Text[50];
                    PdfFileName: Text[50];
                    iStream: InStream;
                begin
                    CurrPage.SetSelectionFilter(saleshdr);
                    ZipFileName := 'SalesOrders_' + Format(CurrentDateTime) + '.zip';
                    DataCompression.CreateZipArchive();
                    if saleshdr.FindSet() then
                        repeat
                            Clear(OStream);
                            Clear(TempBlob);
                            Clear(recref);
                            Clear(FldRef);
                            TempBlob.CreateOutStream(OStream);
                            RecRef.OPEN(Database::"Sales Header");
                            FldRef := RecRef.Field(saleshdr.fieldno("No."));
                            FldRef.SetRange(saleshdr."No.");
                            if RecRef.FindFirst then begin
                                //RecRef.SetTable(PrintHdr, false);
                                Report.SaveAs(Report::"Work Order", '', ReportFormat::Pdf, oStream, RecRef);
                                TempBlob.CreateInStream(iStream);
                                PdfFileName := Format(saleshdr."No." + '_ Work Order' + '_' + Format(CURRENTDATETIME, 0, '<Day,2><Month,2><Year4><Hours24><Minutes,2><Seconds,2>') + '.pdf');
                                DataCompression.AddEntry(iStream, PdfFileName);
                                //FileManagement.BLOBExport(TempBlob, saleshdr."No." + '_ Work Order' + '_' + Format(CURRENTDATETIME, 0, '<Day,2><Month,2><Year4><Hours24><Minutes,2><Seconds,2>') + '.pdf', true);
                            end;
                        until saleshdr.Next() = 0;
                    TempBlob.CreateOutStream(oStream);
                    DataCompression.SaveZipArchive(oStream);
                    TempBlob.CreateInStream(iStream);
                    DownloadFromStream(iStream, '', '', '', ZipFileName);
                    exit;
                end;
            }
        }
        modify(Reopen)
        {
            trigger OnBeforeAction()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.Reset();
                UserSetup.SetRange("User ID", UserId());
                if UserSetup.FindFirst() then begin
                    if UserSetup.AllowRelease = false then Error('User: %1 does not have permission to change status of sales order back to "open"', UserId());
                end;
            end;
        }
        //DimFix
        // modify(Release)
        // {
        //     trigger OnBeforeAction()
        //     var
        //         GetValues: Codeunit GetDimSetValues;
        //         SalesLine: Record "Sales Line";
        //         DimensionSetEntry: Record "Dimension Set Entry";
        //     begin
        //         SalesLine.Reset();
        //         SalesLine.SetRange("Document No.", Rec."No.");
        //         if SalesLine.FindSet()then repeat DimensionSetEntry.Reset();
        //                 DimensionSetEntry.SetRange("Dimension Set ID", SalesLine."Dimension Set ID");
        //                 DimensionSetEntry.SetFilter("Dimension Code", 'LOC');
        //                 if DimensionSetEntry.FindFirst()then exit
        //                 else
        //                     GetValues.GetDimSetValues(SalesLine."Shortcut Dimension 1 Code", SalesLine."Dimension Set ID");
        //             until SalesLine.Next() = 0;
        //     end;
        // }
    }
    var
        myInt: Integer;
}
