tableextension 60100 "ORBUS.WhseWorksheetLine" extends "Whse. Worksheet Line"
{
    fields
    {
        field(60100; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(60101; "Ship Date"; Date)
        {
            Caption = 'Ship Date';
            DataClassification = CustomerContent;
        }
    }
    trigger OnAfterModify()
    begin
        SetStartShipDate();
    end;
    procedure SetStartShipDate()
    var
        ProdOrder: Record "Production Order";
        WhseShipment: Record "Warehouse Shipment Header";
    begin
        IF Rec."Whse. Document No." = '' then exit;
        if(Rec."Start Date" <> 0D) OR (Rec."Ship Date" <> 0D)then exit;
        Case Rec."Whse. Document Type" of Rec."Whse. Document Type"::Production: begin
            ProdOrder.GET(ProdOrder.Status::Released, Rec."Whse. Document No.");
            Rec."Start Date":=ProdOrder."Starting Date";
        end;
        Rec."Whse. Document Type"::Shipment: begin
            WhseShipment.GET(Rec."Whse. Document No.");
            Rec."Ship Date":=WhseShipment."Shipment Date";
        end;
        End;
    end;
}
