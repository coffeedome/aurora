import { Button } from "@progress/kendo-react-buttons";
import { TextArea } from "@progress/kendo-react-inputs";

const NlpSearch = () => {
  return (
    <div className="m-5 w-50">
      <h4>Chat With My Resume Catalog</h4>
      <TextArea placeholder="E.g. `Give me the top 5 match for AI engineers with at least 5 years of AWS experience in Minneapolis metro`" />
      <div className="w-25 mt-3 justify-content-end">
        <Button className="custom-dark-blue-btn">
          <b>Start Chat</b>
        </Button>
      </div>
    </div>
  );
};

export default NlpSearch;
