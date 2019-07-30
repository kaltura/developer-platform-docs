---
layout: page
title: Player Components 
weight: 110
---

## Existing Components 

Components are any elements that exist on the Player UI, such as buttons or the seekbar. 

### Fullscreen Component

Toggles the full screen state 

| Prop | Description |
|--- |--- |
| Player | Player engine instance |

#### Example

```
//@flow
import { h, FullscreenControl } from 'playkit-js-ui';

export default function customUIPreset(props: any) {
  return (
    <FullscreenControl player={props.player} />
  )
}
```


### Loading Component

Shows black overlay with loading spinner when player is not in `idle`, `loading` or `paused` state.

| Prop | Description |
|--- |--- |
| player | Player engine instance |

#### Example

```
//@flow
import { h, Loading } from 'playkit-js-ui';

export default function customUIPreset(props: any) {
  return (
    <Loading player={props.player} />
  )
}
```


### Seekbar Component

Changes the seekbar state.

| Prop | Description |
|--- |--- |
| player | Player engine instance |
| showFramePreview | Boolean to show frame preview. default: false
| showTimeBubble | Boolean to show time bubble. default: false

#### Example

```
//@flow
import { h, SeekBarControl } from 'playkit-js-ui';

export default function customUIPreset(props: any) {
  return (
    // show both frame preview and time bubble
    <SeekBarControl showFramePreview showTimeBubble player={props.player} />

    // show only time bubble
    <SeekBarControl showTimeBubble player={props.player} />
  )
}
```

### Time Display Component

Displays the current time, duration and remaining time, based on format

| Prop | Description |
|--- |--- |
| player | Player engine instance |
| format | Options are `total`, `current` and `left`. Default is: `current of total` |

#### Example

```
//@flow
import { h, TimeDisplay } from 'playkit-js-ui';

export default function customUIPreset(props: any) {
  return (
    <TimeDisplay format='current / total' player={props.player} />
  )
}
```

## Creating a New Component 

### Dumb component

This component will just be a div wrapper with a `className`

```javascript
const h = KalturaPlayer.ui.h;
const BaseComponent = KalturaPlayer.ui.Components.BaseComponent;

class DumbComponent extends Component {
  render(props) {
    return h('div', {className: 'dumb-component'}, props.children);
  }
}

export default DumbComponent;
```

If you want to use JSX follow this [guide](./custom-ui-preset.md#using-jsx), and use the following JSX syntax:

```javascript
const h = KalturaPlayer.ui.h;
const BaseComponent = KalturaPlayer.ui.Components.BaseComponent;

class DumbComponent extends Component {
  render(props) {
    return <div className="dumb-component">{props.children}</div>;
  }
}

export default DumbComponent;
```

The usage of this component will be:

```javascript
const h = KalturaPlayer.ui.h;
h(DumbComponent, null, h('p', null, 'You can add here any components and html you want and it will be appended to the DumbComponent'));
```

Or, if using JSX:

```html
<DumbComponent>
  <p>You can add here any components and html you want and it will be appended to the DumbComponent</p>
</DumbComponent>
```

### Redux-Store Connected Component

This component will log all player state changes (based on the redux store) and print them as a log.
The `componentDidUpdate` lifecycle function is used.
See all lifecycle functions for components [here](https://preactjs.com/guide/lifecycle-methods). 

The component in this example will also get a prop of additional `className`:

```javascript
//@flow
const h = KalturaPlayer.ui.h;
const BaseComponent = KalturaPlayer.ui.Components.BaseComponent;
const connect = playkit.ui.redux.connect;

const mapStateToProps = state => ({playerState: state.engine.playerState});

class PlayerStateLog extends BaseComponent {
  log = new Array();

  constructor() {
    super({name: 'PlayerStateLog'});
  }

  componentDidUpdate() {
    this.log.push(this.props.playerState.currentState);
  }

  render(props) {
    var className = 'log';
    className += ` ${props.additionalClass}`;

    return h(
      'ul',
      {className: className},
      this.log.map(function(playerState) {
        return h('li', null, playerState);
      })
    );
  }
}

export default connect(mapStateToProps)(PlayerStateLog);
```

The usage of this component will be:

```javascript
const h = KalturaPlayer.ui.h;
h(PlayerStateLog, {additionalClass: 'red-list'});
```

Or, if using JSX, change the `render` method above to:

```javascript
return <ul className={className}>{this.log.map(playerState => <li>{playerState}</li>)}</ul>;
```

And the usage of this component will be:

```html
<PlayerStateLog additionalClass='red-list' />
```

### Creating a component to be included in the core library

If a component is to be made in order to be included in the core library, the same guidelines as above must be applied. 

The main difference is that the dependencies are managed by importing core libraries. Meaning, instead of referring to the components via the `KalturaPlayer.ui.*` path, they can be included like this:

```javascript
import {h, Component} from 'preact';
import {bindActions} from '../../utils/bind-actions';
import BaseComponent from '../base';
```





