import React, { PropTypes } from 'react';
import { render } from 'react-dom';
import { createStore, applyMiddleware, compose } from 'redux';
import { Provider, connect } from 'react-redux';

// Enable Async actions
import thunkMiddleware from 'redux-thunk';

// Polyfill fetch on older browsers
import fetch from 'isomorphic-fetch';

// Components
import ComicList from '../components/ComicList';

// Pure Actions
export const REQUEST_COMICS = 'REQUEST_COMICS';
export function requestComics() {
  return {
    type: REQUEST_COMICS
  };
}

export const RECEIVE_COMICS = 'RECEIVE_COMICS';
export function receiveComics(json) {
  return {
    type: REQUEST_COMICS,
    comics: json.data.children.map(child => child.data)
  };
}

// Thunks
export function fetchComics() {
  debugger;
  return function (dispatch) {
    debugger;
    // Updates UI to show loading bar
    dispatch(requestComics());

    // return fetch(`<API ENDPOINT>`)
    //   .then(response => response.json())
    //   .then(json =>
    //     dispatch(receiveComics(json))
    //   )
  };
}

// Reducers
const initialState = {
  isFetching: false,
  comics: ['hello world']
}

function comicReducers(state=initialState, action=undefined) {
  switch (action.type) {
    case REQUEST_COMICS:
      return Object.assign({}, state, {
        isFetching: true
      })
    case RECEIVE_COMICS:
      return Object.assign({}, initialState, {
        comics: initialState.concat(action.comics)
      })
    default:
      return state;
  }
}

// Map Redux state to component props
function mapStateToProps(state) {
  return {
    isFetching: state.isFetching,
    comics: state.comics
  }
}

// Map Redux actions to component props
function mapDispatchToProps(dispatch) {
  return {
    onIncreaseClick: () => dispatch(fetchComics)
  }
}

// Connected Component
const ComicListApp = connect(
  mapStateToProps,
  mapDispatchToProps
)(ComicList);

// Store
const store = createStore(comicReducers, applyMiddleware(thunkMiddleware));

// Root component
export default (props) => (
  <Provider store={store}>
    <ComicListApp {...props} />
  </Provider>
);
