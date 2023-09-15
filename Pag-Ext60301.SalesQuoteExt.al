pageextension 60301 SalesQuoteExt extends "Sales Quote"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Project No."; Rec."Project No.")
            {
                ApplicationArea = All;
            }
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = false;
        }
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
                SalesHeader.SetLocation(true);
                SalesHeader.Modify(true);
                CurrPage.Update();
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
        modify(Control72)
        {
            Visible = true;
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Industry Shortcut Dimension"; Rec."Industry Shortcut Dimension")
            {
                Caption = 'Industry Code';
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                Customer.Reset();
                Customer.SetRange("No.", Rec."Sell-to Customer No.");
                if Customer.FindFirst()then begin
                    Rec."Industry Shortcut Dimension":=Customer."Shortcut Dimension 6 Code";
                    Rec.Modify();
                end;
            end;
        }
        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                Customer.Reset();
                Customer.SetRange(Name, Rec."Sell-to Customer Name");
                if Customer.FindFirst()then begin
                    Rec."Industry Shortcut Dimension":=Customer."Shortcut Dimension 6 Code";
                    Rec.Modify();
                end;
            end;
        }
    }
}
