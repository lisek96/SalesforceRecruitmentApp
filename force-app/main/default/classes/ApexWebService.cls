@RestResource(UrlMapping='/apexWebService')
global without sharing class ApexWebService {

    private static AccountService accountService = new AccountService();
    private static ApexWebServiceResponseHandler responseHandler = new ApexWebServiceResponseHandler();

    @HttpGet
    global static void getImportantAccountInformation(){
        String accName = RestContext.request.params?.get('accountName');
        if(String.isBlank(accName)){
            responseHandler.handleGetImportantAccountInformationNegativeScenario();
        }
        try{
            Account importantAccount = [SELECT Id FROM Account WHERE Name LIKE : '%' + accName + '%' LIMIT 1];
            responseHandler.handleGetImportantAccountInformationPositiveScenario(importantAccount);
        }catch (QueryException e){
            responseHandler.handleGetImportantAccountInformationNegativeScenario();
        }
    }

    @HttpPost
    global static void createAccount(String billingCountry, String accName){
        Account account = new Account(Name=accName, BillingCountry=billingCountry);
        Integer newAccountDeduplicationResults = 0;
        List<AccountService.AccountDeduplicationResult> deduplicationResult
                = accountService.getDeduplicationResults(new List<Account>{account});
        if(deduplicationResult.size() == 0){
            try {
                insert account;
                responseHandler.handleCreateAccountPositiveScenario(account);
            }catch (DmlException e){
                responseHandler.handleInsertAccountError(e);
            }
        }else{
            responseHandler.handleCreateAccountNegativeDuplicateScenario(deduplicationResult.get(newAccountDeduplicationResults));
        }
    }
}