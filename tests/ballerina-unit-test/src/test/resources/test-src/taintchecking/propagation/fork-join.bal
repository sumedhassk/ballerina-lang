public function main (string... args) {
    fork {
        worker w1 {
            "staticData" -> fork;
        }
        worker w2 {
            "staticData" -> fork;
        }
    } join (all) (map<any> results) {
        secureFunction(results, results);
    }
}

function secureFunction (@sensitive any secureIn, any insecureIn) {

}
