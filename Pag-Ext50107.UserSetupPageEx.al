pageextension 50107 UserSetupPageEx extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Allow Posting To")
        {
            field(AllowRelease; rec.AllowRelease)
            {
                ApplicationArea = All;
                Caption = 'Allow Release and Reopen';
                ToolTip = 'When this boolean field is marked to true, then users are able to release and reopen sales orders';
            }
        }
    }
    var myInt: Integer;
}
