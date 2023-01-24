public without sharing class AccountService {

    public List<AccountService.AccountDeduplicationResult> getDeduplicationResults(List<Account> newAccounts){
        List<Datacloud.FindDuplicatesResult> deduplicationResults =
                Datacloud.FindDuplicates.findDuplicates(newAccounts);
        return provideDeduplicationResults(newAccounts, deduplicationResults);
    }

    public List<AccountService.AccountDeduplicationResult> provideDeduplicationResults
            (List<Account> newAccounts, List<Datacloud.FindDuplicatesResult> salesforceDeduplicationResults){
        List<AccountDeduplicationResult> deduplicationResults = new List<AccountDeduplicationResult>();
        if(salesforceDeduplicationResults[0]?.duplicateResults[0]?.getErrorMessage() == null){
            return deduplicationResults;
        }
        for (Integer n=0; n<salesforceDeduplicationResults.size(); n++) {
            AccountDeduplicationResult deduplicationResult = new AccountDeduplicationResult();
            deduplicationResult.newAccount = newAccounts[n];
            for (Datacloud.DuplicateResult dupeResult : salesforceDeduplicationResults[n].getDuplicateResults()) {
                for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
                    for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                        Account duplicateAccount = (Account) matchRecord.getRecord();
                        deduplicationResult.matchConfidences.add(matchRecord.matchConfidence);
                        deduplicationResult.possibleDuplicateAccounts.add(duplicateAccount);
                    }
                }
            }
            deduplicationResults.add(deduplicationResult);
        }
        return deduplicationResults;
    }

    public class AccountDeduplicationResult{
        public Account newAccount;
        public List<Double> matchConfidences = new List<Double>();
        public List<Account> possibleDuplicateAccounts = new List<Account>();
    }
}