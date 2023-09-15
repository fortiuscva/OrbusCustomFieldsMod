tableextension 50100 ItemEx extends Item
{
    fields
    {
        // Add changes to table fields here
        field(50100; IN_ExtendedDescription; text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Extended Description';
        }
        field(50101; IN_Queue; text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Queue';
            TableRelation = IN_Queue;
        }
    }
    var myInt: Integer;
}
