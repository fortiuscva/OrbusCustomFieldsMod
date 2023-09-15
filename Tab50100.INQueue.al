table 50100 "IN_Queue"
{
    DataClassification = ToBeClassified;
    LookupPageId = IN_Queue;
    Caption = 'Queue';

    fields
    {
        field(1; IN_Code; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';
        }
        field(2; Description; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
    }
    keys
    {
        key(Key1; IN_Code)
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
