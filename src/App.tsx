import "./App.css";

const App = () => {
  return (
    <>
      <div>Hello World</div>
      <div>This is {process.env.NODE_ENV} environment</div>
    </>
  );
};

export default App;
