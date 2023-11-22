codeunit 60100 "ORBUS.SubscriptionMgt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Batch", 'OnCheckLinesOnBeforeCheckWhseJnlLine', '', false, false)]
    local procedure OnBeforeCode(WarehouseJournalLine: Record "Warehouse Journal Line"; var IsHandled: Boolean)
    var
        WhseJnl: Record "Warehouse Journal Line";
        ItemVariant: Record "Item Variant";
    begin
        WhseJnl.SetRange("Journal Template Name", WarehouseJournalLine."Journal Template Name");
        WhseJnl.SetRange("Journal Batch Name", WarehouseJournalLine."Journal Batch Name");
        WhseJnl.SetRange("Location Code", WarehouseJournalLine."Location Code");
        IF WhseJnl.FindSet() then
            repeat
                ItemVariant.Reset();
                ItemVariant.SetRange("Item No.", WhseJnl."Item No.");
                if not ItemVariant.IsEmpty() then begin
                    if WhseJnl."Variant Code" = '' then Error('Variant Code is required for Item %1', WhseJnl."Item No.");
                end;
            until WhseJnl.Next() = 0;
    end;
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Create Pick", 'OnBeforeOnRun', '', false, false)]
    procedure WhseOnBeforeRun(WhseWorksheetLine: Record "Whse. Worksheet Line")
    var
        WhseWorksheet: Record "Whse. Worksheet Line";
    begin
        WhseWorksheet.SetRange("Worksheet Template Name", WhseWorksheetLine."Worksheet Template Name");
        WhseWorksheet.SetRange(Name, WhseWorksheetLine.Name);
        if WhseWorksheet.FindSet() then
            repeat
                WhseWorksheet.SetStartShipDate();
                case WhseWorksheet."Whse. Document Type" of
                    WhseWorksheet."Whse. Document Type"::Shipment:
                        WhseWorksheet.TestField("Ship Date");
                    WhseWorksheet."Whse. Document Type"::Production:
                        WhseWorksheet.TestField("Start Date");
                end;
            until WhseWorksheet.Next() = 0;
    end;

    //DimFix
    // [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterShowDimensions', '', false, false)]
    // local procedure OnAfterShowDimensions(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line")
    // begin
    //     PurchaseLine.SetExtendedShortcutDimensions();
    // end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Assembly Document", 'OnAfterReleaseAssemblyDoc', '', true, true)]
    // local procedure OnAfterReleaseAssemblyDoc(var AssemblyHeader: Record "Assembly Header")
    // var
    //     OrbusAssemblyMgt: Codeunit ORBUSAssemblyMgt;
    // begin
    //     OrbusAssemblyMgt.CreateProdAssemblyBOM(AssemblyHeader);
    // end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnShowDocDimOnBeforeSalesHeaderModify, '', false, false)]
    local procedure OnShowDocDimOnBeforeSalesHeaderModify(var SalesHeader: Record "Sales Header");
    begin
        if (SalesHeader."Shortcut Dimension 1 Code" <> SalesHeader."Location Code") then begin
            ORBSingleInstGbl.SetDimUpdateFromDimWindow(true);
            if (SalesHeader."Shortcut Dimension 1 Code" <> '') then
                SalesHeader.Validate("Location Code", SalesHeader."Shortcut Dimension 1 Code")
            else
                SalesHeader.Validate("Location Code", '');
            ORBSingleInstGbl.SetDimUpdateFromDimWindow(false);
        end
    end;

    var
        ORBSingleInstGbl: Codeunit "ORB Single Instance";
}
