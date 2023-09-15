table 50102 OrbusLocations
{
    DataClassification = ToBeClassified;
    Caption = 'Orbus Locations';
    LookupPageId = OrbusLocationsPage;

    fields
    {
        field(1; OrbusLocation; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ship from Location';
            TableRelation = Location;
        }
        field(2; OrbusState;Enum StateOptions)
        {
            DataClassification = ToBeClassified;
            Caption = 'State';
        }
        field(3; "Orbus State Text"; Text[20])
        {
        }
    }
    keys
    {
        key(Key1; OrbusState)
        {
            Clustered = true;
        }
    }
    var myInt: Integer;
    trigger OnInsert()
    begin
    end;
    trigger OnModify()
    begin
    end;
    trigger OnDelete()
    begin
    end;
    trigger OnRename()
    begin
    end;
}
