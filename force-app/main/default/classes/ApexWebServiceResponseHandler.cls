public without sharing class ApexWebServiceResponseHandler {

    public static SObjectUtils sObjectUtils = new SObjectUtils();

    public void handleGetImportantAccountInformationPositiveScenario(Account importantAccount){
        RestContext.response.statusCode = 200;
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = new AccountFindResponse(importantAccount).serialize();
    }

    public void handleGetImportantAccountInformationNegativeScenario(){
        RestContext.response.statusCode = 404;
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = new AccountFindResponse(null).serialize();
    }

    public void handleCreateAccountPositiveScenario(Account account){
        RestContext.response.statusCode = 200;
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = new AccountCreateResponse(account).serialize();
    }

    public void handleCreateAccountNegativeDuplicateScenario(AccountService.AccountDeduplicationResult deduplicationResult){
        RestContext.response.statusCode = 409;
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = new AccountCreateResponse(deduplicationResult).serialize();
    }

    public void handleInsertAccountError(DmlException e){
        RestContext.response.statusCode = 409;
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = new AccountCreateResponse(e).serialize();
    }

    private class AccountFindResponse{
        Boolean found = false;
        String id = '';

        AccountFindResponse(Account account){
            this.found = account != null;
            this.id = account?.Id;
        }

        Blob serialize(){
            return Blob.valueOf(JSON.serialize(this));
        }
    }

    private class AccountCreateResponse{
        Boolean created = false;
        String error = '';
        String accountId = '';
        Boolean duplicatesFound = false;
        List<String> duplicateIds = new List<String>();
        List<Double> duplicateMatchConfidences = new List<Double>();

        AccountCreateResponse(Account account){
            created = true;
            accountId = account.Id;
        }

        AccountCreateResponse(AccountService.AccountDeduplicationResult deduplicationResult){
            duplicatesFound = true;
            duplicateIds = sObjectUtils.toIds(deduplicationResult.possibleDuplicateAccounts);
            duplicateMatchConfidences = deduplicationResult.matchConfidences;
        }

        AccountCreateResponse(DmlException e){
            error = e.getMessage();
        }

        Blob serialize(){
            return Blob.valueOf(JSON.serialize(this));
        }
    }
}