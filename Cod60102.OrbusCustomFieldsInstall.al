codeunit 60102 OrbusCustomFieldsInstall
{
    Subtype = Install;

    trigger OnInstallAppPerCompany();
    var
    begin
    //HandleReinstall();
    end;
    local procedure HandleReinstall();
    var
        Rec: Record Customer;
        ShipToAdd: Record "Ship-to Address";
        DefaultDim: Record "Default Dimension";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.get();
        IF REc.FindSet()then repeat IF ShipToAdd.GET(Rec."No.", Rec."Ship-to Code")then Rec."Default Ship-to City":=ShipToAdd.City
                else
                begin
                    ShipToAdd.reset;
                    ShipToAdd.SetRange("Customer No.", Rec."No.");
                    if ShipToAdd.FindFirst()then Rec."Default Ship-to City":=ShipToAdd.City;
                end;
                DefaultDim.reset;
                DefaultDim.SetRange("Table ID", Database::Customer);
                DefaultDim.SetRange("No.", Rec."No.");
                if DefaultDim.FindSet()then repeat Case true of DefaultDim."Dimension Code" = GLSetup."Global Dimension 1 Code": Rec."Global Dimension 1 Code":=DefaultDim."Dimension Value Code";
                        DefaultDim."Dimension Code" = GLSetup."Global Dimension 2 Code": Rec."Global Dimension 2 Code":=DefaultDim."Dimension Value Code";
                        DefaultDim."Dimension Code" = GLSetup."Shortcut Dimension 3 Code": Rec."Shortcut Dimension 3 Code":=DefaultDim."Dimension Value Code";
                        DefaultDim."Dimension Code" = GLSetup."Shortcut Dimension 4 Code": Rec."Shortcut Dimension 4 Code":=DefaultDim."Dimension Value Code";
                        DefaultDim."Dimension Code" = GLSetup."Shortcut Dimension 5 Code": Rec."Shortcut Dimension 5 Code":=DefaultDim."Dimension Value Code";
                        DefaultDim."Dimension Code" = GLSetup."Shortcut Dimension 6 Code": Rec."Shortcut Dimension 6 Code":=DefaultDim."Dimension Value Code";
                        DefaultDim."Dimension Code" = GLSetup."Shortcut Dimension 7 Code": Rec."Shortcut Dimension 7 Code":=DefaultDim."Dimension Value Code";
                        DefaultDim."Dimension Code" = GLSetup."Shortcut Dimension 8 Code": Rec."Shortcut Dimension 8 Code":=DefaultDim."Dimension Value Code";
                        End;
                    until DefaultDim.Next() = 0;
                Rec.Modify();
            until Rec.Next() = 0;
    end;
}
