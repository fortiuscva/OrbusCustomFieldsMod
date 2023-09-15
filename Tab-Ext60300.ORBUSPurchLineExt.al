tableextension 60300 "ORBUS.PurchLineExt" extends "Purchase Line"
{
    fields
    {
        field(60300; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(3), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(60301; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(4), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 3 Code");
            end;
        }
        field(60302; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(5), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(60303; "Shortcut Dimension 6 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(6), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(60304; "Shortcut Dimension 7 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(7), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(60305; "Shortcut Dimension 8 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(8), Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        modify("Dimension Set ID")
        {
        trigger OnAfterValidate()
        begin
            SetExtendedShortcutDimensions();
        end;
        }
    }
    procedure SetExtendedShortcutDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
        ShortcutDimCodes: array[8]of Code[20];
    begin
        DimMgt.GetShortcutDimensions(Rec."Dimension Set ID", ShortcutDimCodes);
        Rec."Shortcut Dimension 3 Code":=ShortcutDimCodes[3];
        Rec."Shortcut Dimension 4 Code":=ShortcutDimCodes[4];
        Rec."Shortcut Dimension 5 Code":=ShortcutDimCodes[5];
        Rec."Shortcut Dimension 6 Code":=ShortcutDimCodes[6];
        Rec."Shortcut Dimension 7 Code":=ShortcutDimCodes[7];
        Rec."Shortcut Dimension 8 Code":=ShortcutDimCodes[8];
    end;
}
