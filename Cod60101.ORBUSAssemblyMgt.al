codeunit 60101 ORBUSAssemblyMgt
{
    trigger OnRun()
    begin
    end;
    var SalesLine: Record "Sales Line";
    MfgSetup: Record "Manufacturing Setup";
    ProdOrderLine: Record "Prod. Order Line";
    ProdOrderComp: Record "Prod. Order Component";
    TempOldProdOrderComp: Record "Prod. Order Component" temporary;
    CalcProdOrder: Codeunit "Calculate Prod. Order";
    NextProdOrderLineNo: Integer;
    InsertNew: Boolean;
    SalesLineIsSet: Boolean;
    procedure CreateProdAssemblyBOM(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
        Item: Record Item;
        ProdHeader: Record "Production Order";
        ProdHeader2: Record "Production Order";
        ProdLine: Record "Prod. Order Line";
        StockKeepingUnit: Record "Stockkeeping Unit";
        ATOLink: Record "Assemble-to-Order Link";
        SalesHeader: Record "Sales Header";
        LineNo: Integer;
        OrbusAssemblyMgt: Codeunit ORBUSAssemblyMgt;
        ErrorOccurred: Boolean;
    begin
        if not ATOLink.Get(AssemblyHeader."Document Type", AssemblyHeader."No.")then exit;
        if not SalesHeader.Get(ATOLink."Document Type", ATOLink."Document No.")then exit;
        AssemblyLine.reset;
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        IF AssemblyLine.FindSet()then repeat Clear(ErrorOccurred);
                Item.Get(AssemblyLine."No.");
                StockKeepingUnit.Get(AssemblyLine."Location Code", item."No.", AssemblyLine."Variant Code");
                IF StockKeepingUnit."Production BOM No." <> '' then begin
                    ProdHeader.Reset();
                    ProdHeader.SetRange("Source Type", ProdHeader."Source Type"::"Sales Header");
                    ProdHeader.SetRange("Source No.", SalesHeader."No.");
                    if not ProdHeader.FindFirst()then begin
                        Clear(ProdHeader);
                        ProdHeader.init;
                        ProdHeader.Status:=ProdHeader.Status::Released;
                        ProdHeader.insert(true);
                        ProdHeader.validate("Source Type", ProdHeader."Source Type"::"Sales Header");
                        ProdHeader."Source No.":=SalesHeader."No.";
                        ProdHeader.Description:=AssemblyHeader.Description;
                        ProdHeader."Description 2":=AssemblyHeader."Description 2";
                        ProdHeader."Sales Order No.":=SalesHeader."No.";
                        ProdHeader.Modify(true);
                    end;
                    //ProdHeader.Validate(Quantity, AssemblyLine.Quantity);
                    ProdLine.Reset();
                    ProdLine.SetRange("Prod. Order No.", ProdHeader."No.");
                    ProdLine.SetRange(Status, ProdHeader.Status);
                    prodline.SetRange("Item No.", Item."No.");
                    if not ProdLine.FindFirst()then begin
                        ProdLine.reset;
                        ProdLine.SetRange("Prod. Order No.", ProdHeader."No.");
                        ProdLine.SetRange(Status, ProdHeader.Status);
                        If Prodline.FindLast()then NextProdOrderLineNo:=Prodline."Line No." + 10000
                        else
                            NextProdOrderLineNo:=10000;
                        CreateProdOrderLine(ProdHeader, AssemblyLine."Variant Code", ErrorOccurred, Item."No.", AssemblyLine);
                        // ProdLine.Reset();
                        // ProdLine.SetRange("Prod. Order No.", ProdHeader."No.");
                        // ProdLine.SetRange(Status, ProdHeader.Status);
                        // if ProdLine.FindLast() then
                        //     LineNo := ProdLine."Line No." + 10000
                        // else
                        //     LineNo := 10000;
                        // clear(ProdLine);
                        // ProdLine.Init();
                        // ProdLine."Prod. Order No." := ProdHeader."No.";
                        // ProdLine."Line No." := LineNo;
                        // Prodline.Status := ProdHeader.Status;
                        // Prodline.Insert(true);
                        // Prodline.Validate("Item No.", Item."No.");
                        commit;
                    end;
                // ProdHeader2.Reset();
                // ProdHeader2.SetRange(Status, ProdHeader.Status);
                // ProdHeader2.SetRange("No.", ProdHeader."No.");
                // ProdHeader2.FindSet();
                // REPORT.RunModal(REPORT::"Refresh Production Order", false, true, ProdHeader2);
                // Commit();
                end;
            until AssemblyLine.Next() = 0;
    end;
    procedure CreateProdOrderLine(ProdOrder: Record "Production Order"; VariantCode: Code[10]; var ErrorOccured: Boolean; ItemNo: Code[20]; AssemblyLine: Record "Assembly Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        //NextProdOrderLineNo := 10000;
        InsertNew:=false;
        InitProdOrderLine(ItemNo, VariantCode, ProdOrder."Location Code", ProdOrder);
        ProdOrderLine.Description:=AssemblyLine.Description;
        ProdOrderLine."Description 2":=AssemblyLine."Description 2";
        ProdOrderLine.Validate(Quantity, AssemblyLine.Quantity);
        ProdOrderLine.UpdateDatetime();
        ProdOrderLine.Insert();
        if ProdOrderLine.HasErrorOccured()then ErrorOccured:=true;
    end;
    local procedure DeleteLinesForProductionOrder(ProductionOrder: Record "Production Order")
    var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        if IsHandled then exit;
        ProdOrderLine.LockTable();
        ProdOrderLine.SetRange(Status, ProductionOrder.Status);
        ProdOrderLine.SetRange("Prod. Order No.", ProductionOrder."No.");
        ProdOrderLine.DeleteAll(true);
    end;
    local procedure InitProdOrderLine(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; ProdOrder: Record "Production Order")
    var
        Item: Record Item;
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        if IsHandled then exit;
        ProdOrderLine.Init();
        ProdOrderLine.SetIgnoreErrors();
        ProdOrderLine.Status:=ProdOrder.Status;
        ProdOrderLine."Prod. Order No.":=ProdOrder."No.";
        ProdOrderLine."Line No.":=NextProdOrderLineNo;
        ProdOrderLine."Routing Reference No.":=ProdOrderLine."Line No.";
        ProdOrderLine.Validate("Item No.", ItemNo);
        ProdOrderLine."Location Code":=LocationCode;
        ProdOrderLine.Validate("Variant Code", VariantCode);
        if(LocationCode = ProdOrder."Location Code") and (ProdOrder."Bin Code" <> '')then ProdOrderLine.Validate("Bin Code", ProdOrder."Bin Code")
        else
            CalcProdOrder.SetProdOrderLineBinCodeFromRoute(ProdOrderLine, ProdOrderLine."Location Code", ProdOrderLine."Routing No.");
        Item.Get(ItemNo);
        ProdOrderLine."Scrap %":=Item."Scrap %";
        ProdOrderLine."Due Date":=ProdOrder."Due Date";
        ProdOrderLine."Starting Date":=ProdOrder."Starting Date";
        ProdOrderLine."Starting Time":=ProdOrder."Starting Time";
        ProdOrderLine."Ending Date":=ProdOrder."Ending Date";
        ProdOrderLine."Ending Time":=ProdOrder."Ending Time";
        ProdOrderLine."Planning Level Code":=0;
        ProdOrderLine."Inventory Posting Group":=Item."Inventory Posting Group";
        ProdOrderLine.UpdateDatetime();
        ProdOrderLine.Validate("Unit Cost");
        NextProdOrderLineNo:=NextProdOrderLineNo + 10000;
    end;
    local procedure InsertProdOrderLine(): Boolean var
        ProdOrderLine3: Record "Prod. Order Line";
        IsHandled: Boolean;
    begin
        ProdOrderLine3:=ProdOrderLine;
        ProdOrderLine3.SetRange(Status, ProdOrderLine.Status);
        ProdOrderLine3.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderLine3.SetRange("Item No.", ProdOrderLine."Item No.");
        ProdOrderLine3.SetRange("Variant Code", ProdOrderLine."Variant Code");
        ProdOrderLine3.SetRange("Location Code", ProdOrderLine."Location Code");
        ProdOrderLine3.SetRange("Planning Level Code", ProdOrderLine."Planning Level Code");
        IsHandled:=false;
        if not IsHandled then if(not InsertNew) and ProdOrderLine3.FindFirst()then begin
                CopyProdOrderCompToTemp(ProdOrderLine3);
                ProdOrderLine3.Validate(Quantity, ProdOrderLine3.Quantity + ProdOrderLine.Quantity);
                AdjustDateAndTime(ProdOrderLine3, ProdOrderLine."Due Date", ProdOrderLine."Ending Date", ProdOrderLine."Ending Time");
                if ProdOrderLine3."Planning Level Code" < ProdOrderLine."Planning Level Code" then begin
                    ProdOrderLine3."Planning Level Code":=ProdOrderLine."Planning Level Code";
                    UpdateCompPlanningLevel(ProdOrderLine3);
                end;
                ProdOrderLine3.Modify();
                ProdOrderLine:=ProdOrderLine3;
                exit(false);
            end;
        ProdOrderLine.Insert();
        exit(true);
    end;
    local procedure ProcessProdOrderLines(Direction: Option Forward, Backward; LetDueDateDecrease: Boolean; ProdOrder: Record "Production Order"): Boolean var
        ErrorOccured: Boolean;
        IsHandled: Boolean;
    begin
        ProdOrderLine.SetRange(Status, ProdOrder.Status);
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
        if ProdOrderLine.FindSet(true)then repeat IsHandled:=false;
                if not IsHandled then begin
                    CalcProdOrder.SetParameter(true);
                    if not CalcProdOrder.Calculate(ProdOrderLine, Direction, true, true, true, LetDueDateDecrease)then ErrorOccured:=true;
                end;
            until ProdOrderLine.Next() = 0;
        // ProdOrder.AdjustStartEndingDate();
        // ProdOrder.Modify();
        exit(not ErrorOccured);
    end;
    local procedure AdjustDateAndTime(var ProdOrderLine3: Record "Prod. Order Line"; DueDate: Date; EndingDate: Date; EndingTime: Time)
    begin
        if ProdOrderLine3."Due Date" > DueDate then ProdOrderLine3."Due Date":=DueDate;
        if ProdOrderLine3."Ending Date" > EndingDate then begin
            ProdOrderLine3."Ending Date":=EndingDate;
            ProdOrderLine3."Ending Time":=EndingTime;
        end
        else if(ProdOrderLine3."Ending Date" = EndingDate) and (ProdOrderLine3."Ending Time" > EndingTime)then ProdOrderLine3."Ending Time":=EndingTime;
        ProdOrderLine3.UpdateDatetime();
    end;
    local procedure UpdateCompPlanningLevel(ProdOrderLine3: Record "Prod. Order Line")
    var
        ProdOrderComp3: Record "Prod. Order Component";
    begin
        // update planning level code of component
        ProdOrderComp3.SetRange(Status, ProdOrderLine3.Status);
        ProdOrderComp3.SetRange("Prod. Order No.", ProdOrderLine3."Prod. Order No.");
        ProdOrderComp3.SetRange("Prod. Order Line No.", ProdOrderLine3."Line No.");
        ProdOrderComp3.SetFilter("Planning Level Code", '>0');
        if ProdOrderComp3.FindSet(true)then repeat ProdOrderComp3."Planning Level Code":=ProdOrderLine3."Planning Level Code" + 1;
                ProdOrderComp3.Modify();
            until ProdOrderComp3.Next() = 0;
    end;
    local procedure CopyProdOrderCompToTemp(ProdOrderLine3: Record "Prod. Order Line")
    var
        ProdOrderComp2: Record "Prod. Order Component";
    begin
        TempOldProdOrderComp.DeleteAll();
        ProdOrderComp2.SetRange(Status, ProdOrderLine3.Status);
        ProdOrderComp2.SetRange("Prod. Order No.", ProdOrderLine3."Prod. Order No.");
        ProdOrderComp2.SetRange("Prod. Order Line No.", ProdOrderLine3."Line No.");
        if ProdOrderComp2.FindSet()then repeat TempOldProdOrderComp:=ProdOrderComp2;
                TempOldProdOrderComp.Insert();
            until ProdOrderComp2.Next() = 0;
    end;
}
