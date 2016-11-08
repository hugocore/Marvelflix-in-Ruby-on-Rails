import React, { PropTypes } from 'react';
import { render } from 'react-dom';
import ReduxInfiniteScroll from 'redux-infinite-scroll';
import _ from 'lodash';

const InfiniteScroll = ReduxInfiniteScroll;

// React component
export default class ComicList extends React.Component {
  constructor(props) {
    super(props);
  }
  render() {
    return (
      <div>
        <span>Fecting: {this.props.isFetching}</span>
        <h1>Comics</h1>
        <span>{this.props.comics}</span>
        <button onClick={this.props.onIncreaseClick}>Increase</button>
      </div>
    )
  }
}

// Component
// export default class ComicList extends React.Component {
//   constructor(props) {
//     super(props);
//     this.state = {
//       comics: this._createComics(),
//       loadingMore: false
//     }
//   }

//   _createComics(arr=[],start=0) {
//     arr = _.cloneDeep(arr);
//     for (var i=start;i<start+50;i++) {
//       arr.push(i)
//     }
//     return arr;
//   }

//   _loadMore() {
//     this.setState({loadingMore: true});
//     setTimeout(() => {
//       const comics = this._createComics(this.state.comics, this.state.comics.length+1);
//       this.setState({ comics: comics, loadingMore: false })
//     }, 1000)
//   }

//   _renderComics() {
//     return this.state.comics.map((msg) => {
//       return(
//         <div className="item" key={msg}>{msg}</div>
//       )
//     })
//   }

//   render() {
//     return (
//       <div>
//         <InfiniteScroll loadingMore={this.state.loadingMore} elementIsScrollable={false} loadMore={this._loadMore.bind(this)}>
//           {this._renderComics()}
//         </InfiniteScroll>
//       </div>
//     );
//   }
// }
