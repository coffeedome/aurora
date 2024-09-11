import {
  createManagedAuthAdapter,
  createStorageBrowser,
  elementsDefault,
} from "@aws-amplify/ui-react-storage/browser";
import "@aws-amplify/ui-react-storage/storage-browser-styles.css";

export const { StorageBrowser } = createStorageBrowser({
  elements: elementsDefault,
  config: createManagedAuthAdapter({
    credentialsProvider: async () => {
      // return credentials object
      return {
        credentials: {
          accessKeyId: "",
          secretAccessKey: "",
          sessionToken: "",
          expiration: new Date(),
        },
      };
    },
    region: "us-west-2",
    accountId: "123456789102",
    registerAuthListener: (onAuthStateChange) => {},
  }),
});
