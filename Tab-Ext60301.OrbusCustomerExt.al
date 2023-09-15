tableextension 60301 "Orbus.CustomerExt" extends Customer
{
    fields
    {
        field(60300; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(3), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(60301; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(4), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(60302; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(5), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(60303; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(6), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(60304; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(7), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(60305; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(8), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(60306; "Needs Magento ID"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60307; "Last Visit Date"; Date)
        {
            Caption = 'Last Visit Date';
            DataClassification = CustomerContent;
        }
        field(60308; "Default Ship-to City"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        modify("Ship-to Code")
        {
        trigger OnAfterValidate()
        var
            ShipToAdd: Record "Ship-to Address";
        begin
            IF ShipToAdd.GET(Rec."No.", Rec."Ship-to Code")then "Default Ship-to City":=ShipToAdd.City
            else
            begin
                ShipToAdd.reset;
                ShipToAdd.SetRange("Customer No.", Rec."No.");
                if ShipToAdd.FindFirst()then "Default Ship-to City":=ShipToAdd.City;
            end;
        end;
        }
    }
}
