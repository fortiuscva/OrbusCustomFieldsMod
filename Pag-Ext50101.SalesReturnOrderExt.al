pageextension 50101 SalesReturnOrderExt extends "Sales Return Order"
{
    layout
    {
        modify("Ship-to Address")
        {
            Visible = true;
        }
        modify("Ship-to Address 2")
        {
            Visible = true;
        }
        modify("Ship-to City")
        {
            Visible = true;
        }
        modify("Ship-to County")
        {
            Visible = true;

            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                SalesHeader.Get(Rec."Document Type", Rec."No.");
                SalesHeader:=Rec;
                SalesHeader.Modify(true);
                CurrPage.Update(false);
            end;
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = true;
        }
        modify("Ship-to Post Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = false;
        }
    }
}
