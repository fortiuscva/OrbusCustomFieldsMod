pageextension 60101 "ORBUS.WhseItemJnlExt" extends "Whse. Item Journal"
{
    layout
    {
        modify("Variant Code")
        {
            ShowMandatory = IsVariantReq;
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        Item: Record "Item";
        ItemVariant: Record "Item Variant";
    begin
        if Item.Get(Rec."Item No.")then begin
            ItemVariant.Reset();
            ItemVariant.SetRange("Item No.", Item."No.");
            IsVariantReq:=NOT ItemVariant.IsEmpty();
        end;
    end;
    var IsVariantReq: Boolean;
}
